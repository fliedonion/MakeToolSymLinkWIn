Create Windows Symbolic Link
============================

Create or Replace Symbolic link for Windows portable tools.

You can switch the tool version more easy.


Summary
============================

`makeSymLink.cmd c:\opt\_files\SomeTools\SomeTools-1.1.5`

will be

1. Remove `c:\opt\SomeTools` directory ( using `rmdir c:\opt\SomeTools` )

2. Create directory symlink `c:\opt\SomeTools` to `c:\opt\_files\SomeTools\SomeTools-1.1.5`




### Tested on:

* Windows 8.1

Recommend Windws 7 or later

#### note:   
Windows XP's symlink or junction have unexpected behavior.  
ex: when remove symlink directory, older version's windows delete all files (does not delete only symlink).



### Restrict:

* You must create `c:\opt` directory first.
* Tools store directory must contains `:\opt\_files\`.
* Create symlink using absolute path ( even if tools stored directory is in C-drive ).
* Create directory symlink only.

