# Changelog

## v.1.3.0 - May 11, 2013

* Enhance `version` to allow for a compact form, e.g. ``version MyAPP::VERSION, :compact => true`` so that doing `--version` only shows the
  app name and version, not the entire help screen.  See [64].
* Allow using DSL methods before the call to `main`, even though you really shouldn't.  See [65]

[64]: https://github.com/davetron5000/methadone/issues/64
[65]: https://github.com/davetron5000/methadone/issues/65

## v.1.2.6 - Mar 10, 2013

* Need `rspec` as a real dev dependency since it's not part of Aruba any longer.  See [61].

[61]: https://github.com/davetron5000/methadone/issues/61

## v.1.2.5 - Feb 24, 2013

* Compatibility Bundler 1.3 - Bundler 1.3 bootstraps files differently than 1.2, and methadone's generated binfile ends up requiring a non-existent file.  This verison works with both 1.2 and 1.3 of bundler by parsing its output to figure out which file to include.

## v.1.2.4 - Dec 26, 2012

* Fix for my fix on apps with dashes in their name (see [59], thanks to [@terryfinn]

[@terryfinn]: https://github.com/terryfinn
[59]: https://github.com/davetron5000/methadone/pull/59

## v.1.2.3 - Dec 8, 2012

* Can create an app with a dash in its name (See [55])
* Help switches, `-h`, and `--help` are documented in help output (See [51])
* Improve cucumber step requiring docs and fix bug where said docs had to start with a three-letter words (See [37])

[37]: http://github.com/davetron5000/methadone/issues/37
[51]: http://github.com/davetron5000/methadone/issues/51
[55]: http://github.com/davetron5000/methadone/issues/55

## v1.2.2 - Oct 21, 2012

* Generated Rakefile has better formatted code (See [57])
* Error output preface now says "stderr is" instead of "error output", which is less confusing (See [53])
* Less scary stdout/stderr prefixing from SH, courtesy @yoni

[57]: http://github.com/davetron5000/methadone/issues/57
[53]: http://github.com/davetron5000/methadone/issues/53

## v1.2.1 - Jun 10, 2012, 3:41 PM

* Slightly loosen what passes for a one-line description of the app, courtesy @jredville

## v1.2.0 - May 21, 2012, 11:05 PM

* Better handling of `open4` dependency when you don't install it and you don't use it.
* Quoted spaced strings in config files and env var weren't working.  Now they are.
* Use the current version in generated gemspec
* Non-string arguments (such as Regexps for validation and classes for type conversion) were not working.  Now they are.
* `sh` can now be used more safely by passing an array to avoid tokenization (thanks @gchpaco!)

## v1.1.0 - April 21, 2012, 6:00 PM

* Can bootstrap apps using RSpec instead of Test::Unit (thanks @msgehard)

## v1.0.0 - April 1, 2012, 10:31

* Initial official release
