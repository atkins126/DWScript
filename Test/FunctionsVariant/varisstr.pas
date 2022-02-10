procedure Test(v : Variant);
begin
   Print(v);
   PrintLn(' is ' + if VarIsStr(v) then 'string' else 'not string');
end;

var v : Variant;
Test(v);

Test(1);
Test(Null);
Test(Unassigned);

type TTest = class (IInterface) end;
var i : IInterface;
Test(i);
i := new TTest;
Test(i);

Test(JSON.Parse('123'));
Test(JSON.Parse('[123]'));
Test(JSON.Parse('["hello"]')[0]);
Test(JSON.Parse('[123]')[1]);
Test(JSON.Parse('null'));
Test(JSON.Parse('{"a":false}').a);
Test(JSON.Parse('{"a":false}').b);