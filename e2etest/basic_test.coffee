casper = require("casper").create()

casper.start "http://localhost:8081"

casper.then ->
    @test.assertExists "textarea#code", "textarea for code is there"

casper.then ->
    @evaluate ->
        window.editor.setValue "sticazzi"
    @capture "codelab2.png"

casper.then ->
    @test.assertEqual "sticazzi",
                        (@evaluate -> 
                            window.editor.getValue()),
                          "sticazzi is sticazzi"
casper.run()
