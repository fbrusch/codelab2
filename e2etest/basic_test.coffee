casper = require("casper").create()

casper.start "http://localhost:8081"

casper.then ->
    @test.assertExists "textarea#code", "textarea for code is there"
    @test.assert (@evaluate ->
        window.editor?), "check if editor object is there"
    @test.assert (@evaluate ->
        window.codeConsole?), "check if codeConsole object is there"

casper.then ->
    @evaluate ->
        window.editor.setValue "sticazzi"
    @test.assertEqual "sticazzi",
                        (@evaluate -> 
                            window.editor.getValue()),
                          "checking code editor is there and writable"

casper.then ->
    @test.assertExists "button#submit", "checking that *submit* button is there"


casper.then ->
    @evaluate ->
        window.editor.setValue "#include <stdio.h>\nint main(){printf (\"hello world!\\n\");}"
    @click "button#submit"
    @waitFor ->
        @evaluate ->
            return window.execFinished == true
        -> #then
            result = @evaluate ->
                return window.codeConsole.getValue()
            @test.assertEqual "hello world!", result
        -> #ontimeout
            @test.error "Execution timed out"
casper.run()
