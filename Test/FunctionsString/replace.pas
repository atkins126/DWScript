﻿PrintLn(StrReplace('hello', 'world', 'bug'));
PrintLn(StrReplace('', 'world', 'bug'));
PrintLn(StrReplace('hello', 'hello', 'world'));
PrintLn(StrReplace('hello', 'hello', ''));
PrintLn(StrReplace('hello', '', 'world'));

PrintLn(StrReplace('hello', 'l', 'z'));
PrintLn(StrReplace('hello', 'h', 'z'));
PrintLn(StrReplace('hello', 'o', 'z'));

PrintLn(StrReplace('hello', 'l', 'xyz'));
PrintLn(StrReplace('hello', 'h', 'xyz'));
PrintLn(StrReplace('hello', 'o', 'xyz'));

PrintLn(StrReplace('abacaba', 'ab', 'z'));
PrintLn(StrReplace('abacaba', 'aba', 'z'));

PrintLn(StrReplace('bacaba', 'ba', 'zx'));
PrintLn(StrReplace('bacaba', 'ba', 'z'));
PrintLn(StrReplace('bacaba', 'ba', 'xyz'));

PrintLn(StrReplace('bacaba', 'ca', 'zx'));
PrintLn(StrReplace('bacaba', 'ca', 'z'));
PrintLn(StrReplace('bacaba', 'ca', 'xyz'));

PrintLn(StrReplace('bacaba', 'a', 'z'));
PrintLn(StrReplace('bacaba', 'a', 'zx'));
PrintLn(StrReplace('bacaba', 'a', ''));

PrintLn(StrReplace('bacaba', 'b', 'z'));
PrintLn(StrReplace('bacaba', 'b', 'zx'));
PrintLn(StrReplace('bacaba', 'b', ''));

