var a : array of Integer = [ 3, 5, 7, 11 ];

PrintLn(a.Map(IntToStr).Join(','));

PrintLn(a.Map(IntToStr).Map(lambda (s) => '"' + s + '"').Join(','));