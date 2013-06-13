casper = require("casper").create()

casper.start "http://localhost:8081"

casper.then ->
    @test.assertExists "textarea#code", "textarea for code is there"

casper.then ->
    @evaluate ->
        window.editor.setValue "sticazzi"

casper.then ->
    @test.assertEqual "sticazzi",
                        (@evaluate -> 
                            window.editor.getValue()),
                          "code editor is there and writable"

casper.then ->
    @test.assertExists "button#submit", "submit button is there"

casper.then ->

casper.run()
