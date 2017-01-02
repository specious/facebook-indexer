Browse and share your favorite Facebook pages.

![Screenshot](https://raw.githubusercontent.com/specious/facebook-wall/master/screenshot.png)

## Instructions

First install and configure [facebook-cli](https://github.com/specious/facebook-cli). Then run:

```
make
```

By default, icons are 180 pixels tall. A different size can be requested with:

```
make ICON_HEIGHT=92
```

Valid sizes range from 24 to 180 pixels.

## What's up with the "?" icons?

A small percentage of pages show up as a question mark instead of a profile picture:

!["?" icon](https://raw.githubusercontent.com/specious/facebook-wall/master/doc/images/question-mark-icon.png)

That is due to the Facebook page's content privacy settings having been set to "custom" rather than "public", and therefore the image cannot be fetched without a Facebook authorization token:

![Shared with: custom](https://raw.githubusercontent.com/specious/facebook-wall/master/doc/images/shared-with-custom.png)

Let the maintainers of those pages know that sharing their content with "public" could allow more people to interact with their content.

## License

ISC
