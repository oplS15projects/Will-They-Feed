# FP7-webpage Title of Project
This is a template for using your repo's README.md as your project web page. 
I recommend you copy and paste into your README file. Delete this line and the one above it, customize everything else. Make it look good!

##Authors
* Nick Lombardi
* Joshua Semedo
* Ron

##Overview
A League of Legends statistics application written in Racket and HTML5 that interfaces with the Riot API to retrieve important information regarding a players performance that is then calculated to determine the likelyhood the player will perform poorly.

##Screenshot
![screenshot showing env diagram](http://i.imgur.com/uXrEimz.png)

##Concepts Demonstrated
* **Abstraction** is used separate the HTML5 file from the Racket Web Server & Data being passed.


##External Technology and Libraries
* Riot API - http://api.riotgames.com
* Racket Web Server Library - http://docs.racket-lang.org/web-server
* JSON Library - http://docs.racket-lang.org/json


##Favorite Lines of Code
####Nick
This is just an example of what I like to write; The nesting tags and strict formatting, in my opinion, make writing code an artform.  I love it when everything comes together perfectly, and displays exdactly how I want it to.
```
            <div class="col-md-8 col-md-offset-2">
                <section class="tile transparent">
                    <div class="jumbotron bg-transparent-black-3 row">
                        <div class="container text-center col-md-6">
                            <img class="inline-block" src="http://lkimg.zamimg.com/shared/riot/images/profile_icons/profileIcon@|icon|" style="width: 64px; vertical-align: top;">
                            <h1 class="inline-block" style="padding-left: 20px; margin-top: 0;">@|name|</h1>
                            <p>Summoner Level</p>
                        </div>
                        <div class="container text-center col-md-6">
                            <h1>@|feederscore|!</h1>
                        </div>
                    </div>
                </section>
            </div>
```

####Josh
This is my favorite code block for a few reasons. I created the feeder-score statistic, and got to make up the metrics for it.  It looks a little messy, but it takes the KDA, adds it to the winloss ratio(after converting it to a decimal), then cuts off the unnecessary digits, then assigns it to the variable x, which then gets passed to the cond block, which will simply output the line of text, telling you how likely you are to feed.

```
    (define feeder-score 
      (let ([x (truncate (* 10 (+ (/ (+ ranked-kills ranked-assists) ranked-deaths) (exact->inexact ranked-win-loss))))])
        (cond [(< x 25)
               (printf "- Feeder Score is ~a, this person is likely to feed.\n" x)]
               [(and (> x 25) (< x 40))
               (printf "- Feeder Score is ~a, this person is average.\n" x)]
               [(> x 40)
               (printf "- Feeder Score is ~a, this person is likely to carry.\n" x)])))
```

####Ron
I like these lines of code because this is the type of code that I helped write that bridges the gap between all of our work; Josh working with racket to get the variables all set up, me using the webserver with his racket code to generate a page, and Nick's html and css code to display it beautifully.
```
<h3 class="panel-title">Solo Queue: @tier @division </h3>
                </div>
                <div class="panel-body">
                    The following are statistics regarding the players Solo-Queue performance. These carry rather significant value.

                    <div class="progress-list" style="margin-top: 15px;">
                        <div class="details">
                            <div class="title"><strong> @soloqwins </strong> / @soloqlosses </div>
                            <div class="description">Ranked Solo Queue Ratio</div>
                        </div>
```

##Additional Remarks
We had a lot of fun with this project because we got to do something we were interested in. Thanks for letting us choose.

#How to Download and Run
Open the Racket file in DrRacket, run the file. Enter a summoner name in the box, then the necessary data will be retrieved and displayed on a web page for your viewing pleasure.

Latest Release: https://github.com/oplS15projects/Will-They-Feed

