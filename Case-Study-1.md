---
title: "CASE STUDY 1"
author: "Tanner Norton"
date: "September 21, 2019"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: hide
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---







## Background
The purpose of this case study is to review data driven visualizations and determine the good/bad of each graphic. 

## Article 1
[Homeruns are Soaring](https://fivethirtyeight.com/features/home-runs-are-soaring-could-declining-backspin-be-a-factor/)

Two good things: I think the legend actually does a great deal of communicating the differences in spin rate that occur between different launch angles. One can easily tell that a ball that is hit at a 35-39 degree launch angle has more backspin than when the ball is hit at a 15-19 degree launch angle. The addition of the gridlines was done well as they are not distracting or masking the data but help one better reference the data. 

One bad thing: This graphic is a facet that shows the spin rate of a baseball upon leaving the bat dependant on the angle it is hit at. As a result the x-axis is way at the bottom and requires to much lookup to quickly understand what the trend is. In other words they could have better displayed the info in a common scale line graph. 

## Article 2
[How many Recessions Have People Lived Through](
https://www.washingtonpost.com/resizer/5XMeVt6D4DjmqJYFfukIkYOuVF8=/1484x0/arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/3X3Q42OKRFEDBBLNT5BVUDTS3I.png)

Two good things: I believe the graph does make good use of both color saturation and hue in order to help the reader know see the differences in the number of recessions and the age groups that are encompassed. I also like that the graph explicitly shows that it wants to show the number of adults who have lived through a recession and therefore those under age 18 are not counted. 

One bad thing: On the x-axis I think they included a line that shows that age increases to the farther to the right. This is intuitive and the numbers already indicate that. I think this should be done away with and the axis could simply be labeled "Age in Years".


## Article 3
[Minor League Baseball](https://fivethirtyeight.com/features/do-we-even-need-minor-league-baseball/)

Two good things:  They used a common scale which allows for easy comparison between the number minor league teams affiliated with the Astros and the Major league average. The graph does use the law of continuity well as it is easy to see the general trend that is taking place. As someone who follows baseball closely I know that in recent years the Astros have had much success and the point of the graphic is to convey that maybe having less minor league affiliates is better for the Major league teams. 

One bad thing: The inclusion of other teams creates to much noise and ends up only being a distraction instead of an aid. The purpose was to show how the Houston Astros are different from the average Major league club in the number of minor league affiliates they have. In doing this they should have just left the graph with the Major league average and the Astros. I also do not like the way the x-axis is labeled because it does not help the reader identify the most recent years very well, which is when the Astros have had success.  


## Article 4
[Annual Fraud Loss](https://priceonomics.com/what-kind-of-online-fraud-is-growing-the-fastest/)

Two good things: They did a good job to organize the data in a pattern taking advantage of the Law of Continuity and not organizing it by alphabetical order. As this is a barplot they did well in making sure that there was spacing between the data otherwise one might read it as a histogram which it is not. 

One bad thing: I would say the sub-title should just be shortend to "Billions of $" getting rid of the part that says "loss associated with type of fraud per year".  I think the seconed part is redundant because the main title already says "loss by category" in it. It is not needed in my opinion but they could put a label on the x-axis saying "Type of Fraud". 


```r
plot(1:20)
```

![](Case-Study-1_files/figure-html/unnamed-chunk-2-1.png)<!-- -->








