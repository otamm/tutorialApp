Sample App for the Rails tutorial.

Regex Table:

/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i :	full regex
/	                                   : start of regex
\A	                                 : match start of a string
[\w+\-.]+	                           : at least one word character, plus, hyphen, or dot
@	                                   : literal “at sign”
[a-z\d\-.]+	                         : at least one letter, digit, hyphen, or dot
\.                                   : literal dot
[a-z]+	                             : at least one letter
\z	                                 : match end of a string
/	                                   : end of regex
i	                                   : case-insensitive
