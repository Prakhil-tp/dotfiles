# Firefox

## customization

Steps to add custom css styles for firefox

1. open firefox and type `about:config` in the addressbar.
2. search for `toolkit.legacyUserProfileCustomizations.stylesheets`, and set it to `true`

Now, let's locate/create the chrome folder in firefox profile directory.

1. Go to profile directory

- Open firefox and type `about:profile` in the addressbar.
- Under "**Root Directory**" click open folder to navigate.
- Create a folder named `chrome/`
  example:

```
 ~/.mozilla/firefox/<your-profile>.default-release/chrome/
```

2. Inside the directory, create or add `userChrome.css` file to customize firefox.
