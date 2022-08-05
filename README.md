# DocBook Omnibus

DocBook Omnibus is an incomplete, unfinished experiment. If it’s ever
finished, it will allow you to publish a book (or a set of books) in a
web application that offers a more dynamic view of the content.

The site and page navigation links are persistently displayed, a
breadcrumb trail is maintained, and I hope to integrate
[static search](https://github.com/projectEndings/staticSearch) as well.

## The story

In October, 2021, Evan Lenz remarked “[I would love to see the CSS styles
from Asciidoctor applied to the output of
xslTNG.](https://github.com/docbook/xslTNG/issues/126)”.

The AsciiDoctor pages that he links to do look nice. I took a quick
peek and quickly became discouraged. My CSS foo isn’t really up to
that level, but critically, the rendering provided there is dependent
not just on CSS but also on JavaScript to manage the changing views.

Fast forward to August, 2022 where Evan presented _XML in an AsciiDoc World: SaxonJS to the Rescue_ at
[Balisage](https://balisage.net).

I hate to leave a good idea unimplemented, so I decided I would give
myself a short, time boxed window to do some experiments. I told
myself I wasn’t going to get any “real” work done in the morning hours
before the conference begins (in this time zone) anyway, so I’d play with this.

It took a bunch of hours to unwind the various CSS techniques used to
render those AsciiDoctor pages. Then it took me a couple of hours to
customize the DocBook xslTNG stylesheets and write a SaxonJS XSLT
stylesheet to render them.

You an see [https://ndw.github.io/DocBookOmnibus](the results) for yourself.

I’ve _just barely_ scratched the surface of what would need to be done
to make this a complete solution.

Off the top of my head…

1. There are still CSS rendering issues in the site navigation bar on
   the left. (More generally, someone with some CSS design skillz
   could sure improve it!)
2. I’ve made no effort to support sets of books, but that’s what the
   “Second panel” text in the site navigation bar is alluding to.
2. None of the DocBook CSS or JavaScript (for example, for
   annotations) is included.
3. None of the intra-document links in the body of the text work.
4. There’s no mechanism for customizing the site header or footer.
5. Page navigation links on the right don’t work very well. The header
   you link to is “behind” the page headers. I think I’ve read how to
   fix that, but I can’t remember what the fix is or where I read it.
6. The browser’s window location isn’t tracking the changes to the
   display. That means you can’t bookmark a particular page.
   
I have reached the end of my time box. I have higher priority projects
shouting loudly for my attention.

But someday, I’d like to pursue this.
