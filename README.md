# Winnow

A tiny Ruby library for document fingerprinting.

## What is document fingerprinting?

Document fingerprinting converts a document (e.g. a book, a piece of code, or
any other string) into a much smaller number of hashes called *fingerprints*. If
two documents share any fingerprints, then this means there is an exact
substring match between the two documents.

Document fingerprinting has many applications, but the most obvious one is for
plagiarism detection. By taking fingerprints of two documents, you can detect if
parts of one document were copied from another.

This library implements a fingerprinting algorithm called *winnowing*, described
by Saul Schleimer, Daniel S. Wilkerson, and Alex Aiken in a paper titled
[*Winnowing: Local Algorithms for Document Fingerprinting*][swa_paper].

## Usage

The `Fingerprinter` class takes care of fingerprinting documents. To create a
fingerprint, you need to provide two parameters, called the *noise threshold*
and the *guarantee threshold*. When comparing two documents' fingerprints, no
match shorter than the noise threshold will be detected, but any match at least
as long as the guarantee threshold is guaranteed to be found.

The proper values for your noise and guarantee thresholds varies by context.
Experiment with the data you're looking at until you're happy with the results.

Creating a fingerprinter is easy:

```ruby
fingerprinter = Winnow::Fingerprinter.new(noise_threshold: 10, guarantee_threshold: 18)
```

Then, use `#fingerprints` get the fingerprints. Optionally, pass `:source`
(default is `nil`) so that Winnow can later report which document a match is
from.

```ruby
document = File.new('hamlet.txt')
fingerprints = fingerprinter.fingerprints(document.read, source: document)
```

`#fingerprints` just returns a plain-old Ruby `Hash`. The keys of the hash are
generated from substrings of the document being fingerprinted. Finding shared
substrings between documents is as simple as seeing if they share any of the
keys in their `#fingerprints` hash.

To keep things easier for you, Winnow comes with a `Matcher` class that will
find matches between two documents.

Here's an example that puts everything together:

```ruby
require 'winnow'

str_a = <<-EOF
'Twas brillig, and the slithy toves
Did gyre and gimble in the wabe;
This is copied.
All mimsy were the borogoves,
And the mome raths outgrabe.
EOF

str_b = <<-EOF
"Beware the Jabberwock, my son!
The jaws that bite, the claws that catch!
Beware the Jubjub bird, and shun
The frumious -- This is copied. -- Bandersnatch!"
EOF

fprinter = Winnow::Fingerprinter.new(
  guarantee_threshold: 13, noise_threshold: 9)

f1 = fprinter.fingerprints(str_a, source: "Stanza 1")
f2 = fprinter.fingerprints(str_b, source: "Stanza 2")

matches = Winnow::Matcher.find_matches(f1, f2)

# Because 'This is copied' is longer than the guarantee threshold, there might
# be a couple of matches found here. For the sake of brevity, let's only look at
# the first match found.
match = matches.first

# It's possible for the same key to appear in a document multiple times (e.g. if
# 'This is copied' appears more than once). Winnow::Matcher will return all
# matches from the same key in array.
#
# In this case, we know there's only one match (because 'This is copied' appears
# only once in each document), so let's only look at the first one.
match_a = match.matches_from_a.first
match_b = match.matches_from_b.first

p match_a.index, match_b.index # 71, 125

match_context_a = str_a[match_a.index - 10 .. match_a.index + 20]
match_context_b = str_b[match_b.index - 10 .. match_b.index + 20]

# Match from Stanza 1: "e wabe;\nThis is copied.\nAll mim"
puts "Match from #{match_a.source}: #{match_context_a.inspect}"

# Match from Stanza 2: "ious -- This is copied. -- Band"
puts "Match from #{match_b.source}: #{match_context_b.inspect}"
```

You may find that `Matcher` doesn't handle your exact use-case. That's not a
problem. [The built-in matcher.rb file](lib/winnow/matcher.rb)
is only about 10 lines of code, so you could easily make your own.

## :boom: :bomb: A major caveat with `String#hash` :bomb: :boom:

In order to avoid [algorithmic complexity attacks][wiki_aca], the value returned
from Ruby's `String#hash` method [changes every time you restart the
interpreter][hash_stackoverflow]:

```sh
$ irb
2.0.0p353 :001 > "hello".hash
 => 482951767139383391
2.0.0p353 :002 > exit

$ irb
2.0.0p353 :001 > "hello".hash
 => 3216751850140847920
2.0.0p353 :002 > exit
```

(This is the case even if you're using JRuby.)

This means that although the winnowing algorithm *should* allow you to
precalculate a document's fingerprints and store them somewhere, doing so in
Ruby will not work unless you're careful to make sure you never restart your
Ruby runtime.

[swa_paper]: http://theory.stanford.edu/~aiken/publications/papers/sigmod03.pdf
[wiki_aca]: http://en.wikipedia.org/wiki/Algorithmic_complexity_attack
[hash_stackoverflow]: http://stackoverflow.com/questions/23331725/why-are-ruby-hash-methods-randomized
