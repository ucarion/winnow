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


```ruby
str1 = <<-EOF
'Twas brillig, and the slithy toves
Did gyre and gimble in the wabe;
This is copied.
All mimsy were the borogoves,
And the mome raths outgrabe.
EOF

str2 = <<-EOF
"Beware the Jabberwock, my son!
The jaws that bite, the claws that catch!
Beware the Jubjub bird, and shun
The frumious -- This is copied. -- Bandersnatch!"
EOF

fprinter = Winnow::Fingerprinter.new(
  guarantee_threshold: 13, noise_threshold: 9)

f1 = fprinter.fingerprints(str1, source: "Stanza 1")
f2 = fprinter.fingerprints(str2, source: "Stanza 2")

Winnow::Matcher.find_matches(f1, f2).each do |match|
  puts "Found a match:"

  match.matches_from_a.each do |loc|
    puts "Line #{loc.line} col #{loc.column} of #{loc.source}"
  end
  match.matches_from_b.each do |loc|
    puts "Line #{loc.line} col #{loc.column} of #{loc.source}"
  end

  puts
end

# Outputs:
#
# Found a match:
# Line 2 col 0 of Stanza 1
# Line 3 col 16 of Stanza 2
#
# Found a match:
# Line 2 col 1 of Stanza 1
# Line 2 col 1 of Stanza 1
# Line 2 col 1 of Stanza 1
# Line 2 col 1 of Stanza 1
# Line 2 col 1 of Stanza 1
# Line 3 col 17 of Stanza 2
# Line 3 col 17 of Stanza 2
# Line 3 col 17 of Stanza 2
# Line 3 col 17 of Stanza 2
# Line 3 col 17 of Stanza 2
#
# Found a match:
# Line 2 col 2 of Stanza 1
# Line 3 col 18 of Stanza 2
#
# Found a match:
# Line 2 col 5 of Stanza 1
# Line 2 col 5 of Stanza 1
# Line 3 col 21 of Stanza 2
# Line 3 col 21 of Stanza 2
# Line 3 col 21 of Stanza 2
```

You may find that `Matcher` doesn't handle your exact use-case. That's not a
problem. [The built-in matcher.rb file](lib/winnow/matcher.rb)
is only about 10 lines of code, so you could easily make your own.

[swa_paper]: http://theory.stanford.edu/~aiken/publications/papers/sigmod03.pdf
