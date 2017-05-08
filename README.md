# pepo

Just an elm-lang demo for my Dad


## What is it, though?

My Dad plays squash and was talking to me about this drill called ghosting and
possibly writing a little computer program to basically call out random
numbers. He was experimenting in VisualBasic, so I thought I'd try approaching
it from a different angle.


## Ok, what is ghosting?

[Ghosting](https://www.google.com/search?q=squash+ghosting) is a solo squash
drill performed without a ball. You're in the court (or I guess you could just
pretend you're in a court) and someone or (some computer program) calls out a
position to you -- you run to that position as though the ball is there and
you're moving to play it and then you return to the center of the court. Some
interval of time passes and the next position is called out.


## Using pepo

Easiest way, just go to https://jonprindiville.github.io/pepo/ (and hopefully
I'll keep it updated...)

... slightly more work:

1. Clone/download this repo
1. [Install elm-lang](https://guide.elm-lang.org/install.html)
1. Navigate into the repo directory
1. ``elm-make --yes pepo.elm``
1. Open the generated ``index.html`` in a browser (or take that ``index.html``
   with you to the squash court on your old laptop or phone or something)
1. Maybe adjust the time interval or choose a time limit.
1. Press start and position numbers will begin appearing at the interval you've
   selected.


## TODO

Possible future features:
- instead of representing positions as six integers, allow user to specify points
  on a faux-squash court, add/remove to have more/less than six
- communicate time limit progress while we're running
- responsive styling (will this work on a phone)
- sounds?


## Why "pepo", though?

Well, [wikipedia](https://en.wikipedia.org/wiki/Cucurbita_pepo) told me that...

> Cucurbita pepo is a cultivated plant of the genus Cucurbita. It yields
> varieties of winter squash and pumpkin, but the most widespread varieties
> belong to Cucurbita pepo subspecies pepo, called summer squash.
