# Unicode UAX9 Bidirectional Algorithm in ActionScript3

An ActionScript3 implementaion of the [Unicode UAX9 Bidirectional Algorithm.](https://unicode.org/reports/tr9/)

> The Unicode Standard prescribes a memory representation order known as logical order. When text is presented in horizontal lines, most scripts display characters from left to right. However, there are several scripts (such as Arabic or Hebrew) where the natural ordering of horizontal text in display is from right to left. If all of the text has a uniform horizontal direction, then the ordering of the display text is unambiguous. However, because these right-to-left scripts use digits that are written from left to right, the text is actually bidirectional: a mixture of right-to-left and left-to-right text. In addition to digits, embedded words from English and other scripts are also written from left to right, also producing bidirectional text. Without a clear specification, ambiguities can arise in determining the ordering of the displayed characters when the horizontal direction of the text is not uniform.

All the code is released to Public Domain. Patches and comments are welcome. It makes me happy to hear if someone finds the implementations useful.

Ehsan Marufi<br />
<sup>October 2016</sup>