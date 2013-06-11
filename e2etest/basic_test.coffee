casper = require("casper").create()

casper.start "http://localhost:8081"

casper.then ->
    @test.assertExists "textarea#code", "textarea for code is there"

casper.then ->
    @sendKeys '//*[@id="dummybodyid"]/div[1]/div[6]', "ciao belli"
    @capture "codelab2.png"

casper.run()
