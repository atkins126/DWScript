{**********************************************************************}
{                                                                      }
{    "The contents of this file are subject to the Mozilla Public      }
{    License Version 1.1 (the "License"); you may not use this         }
{    file except in compliance with the License. You may obtain        }
{    a copy of the License at http://www.mozilla.org/MPL/              }
{                                                                      }
{    Software distributed under the License is distributed on an       }
{    "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express       }
{    or implied. See the License for the specific language             }
{    governing rights and limitations under the License.               }
{                                                                      }
{    Copyright Creative IT.                                            }
{    Current maintainer: Eric Grange                                   }
{                                                                      }
{**********************************************************************}
unit dwsStringIterator;

{$I dws.inc}
{$R-}
{$Q-}


interface

uses System.SysUtils;

type

   TStringIterator = class
      private
         FStr : String;
         FPStr : PChar;
         FPosition : Integer;
         FLength : Integer;

      public
         constructor Create(const s : String);

         function Current : Char; inline;
         function EOF : Boolean; inline;
         procedure Next; inline;

         procedure SkipWhiteSpace;
         procedure SkipUntilEOL;

         function Peek(const aMatchString : String) : Boolean;

         function CollectQuotedString : String;
         function CollectAlphaNumeric : String;
         function CollectAlphaNumericUnderscore : String;
         function CollectInteger : Int64;
         function CollectFloat(var value : Double) : Boolean;

         property Str : String read FStr;
         property Length : Integer read FLength write FLength;
   end;

   EStringIterator = class (Exception) end;

// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------
implementation
// ------------------------------------------------------------------
// ------------------------------------------------------------------
// ------------------------------------------------------------------

uses dwsUtils;

// ------------------
// ------------------ TStringIterator ------------------
// ------------------

// Create
//
constructor TStringIterator.Create(const s : String);
begin
   FStr:=s;
   FPStr:=PChar(Pointer(s));
   FLength:=System.Length(s);
   FPosition:=0;
end;

// Current
//
function TStringIterator.Current : Char;
begin
   if Cardinal(FPosition)<Cardinal(FLength) then
      Result:=FPstr[FPosition]
   else Result:=#0;
end;

// EOF
//
function TStringIterator.EOF : Boolean;
begin
   Result:=(FPosition>=FLength);
end;

// Next
//
procedure TStringIterator.Next;
begin
   Inc(FPosition);
end;

// SkipWhiteSpace
//
procedure TStringIterator.SkipWhiteSpace;
begin
   while (FPosition<FLength) and (Ord(FPStr[FPosition])<=Ord(' ')) do
      Inc(FPosition);
end;

// SkipUntilEOL
//
procedure TStringIterator.SkipUntilEOL;
begin
   while (FPosition<FLength) and not (Ord(FPStr[FPosition]) in [ 10, 13 ]) do
      Inc(FPosition);
end;

// Peek
//
function TStringIterator.Peek(const aMatchString : String) : Boolean;
begin
   var n := System.Length(aMatchString);
   if n = 0 then Exit(True);

   if FPosition + n >= FLength then Exit(False);

   Result := CompareMem(Pointer(aMatchString), @FPstr[FPosition], n * SizeOf(Char));
end;

// CollectQuotedString
//
function TStringIterator.CollectQuotedString : String;
var
   quoteChar : Char;
begin
   quoteChar:=Current;
   Inc(FPosition);
   while not EOF do begin
      if FPstr[FPosition]=quoteChar then begin
         Inc(FPosition);
         if EOF or (FPstr[FPosition]<>quoteChar) then Exit;
         Result:=Result+quoteChar;
      end else begin
         Result:=Result+FPStr[FPosition];
         Inc(FPosition);
      end;
   end;
   raise EStringIterator.Create('Unfinished quoted string');
end;

// CollectAlphaNumeric
//
function TStringIterator.CollectAlphaNumeric : String;
begin
   var start := FPosition;
   while FPosition < FLength do begin
      case FPstr[FPosition] of
         '0'..'9', 'a'..'z', 'A'..'Z' : Inc(FPosition);
      else
         break;
      end;
   end;
   Result := Copy(FStr, start+1, FPosition-start);
end;

// CollectAlphaNumericUnderscore
//
function TStringIterator.CollectAlphaNumericUnderscore : String;
begin
   var start := FPosition;
   while FPosition < FLength do begin
      case FPstr[FPosition] of
         '0'..'9', 'a'..'z', 'A'..'Z', '_' : Inc(FPosition);
      else
         break;
      end;
   end;
   Result := Copy(FStr, start+1, FPosition-start);
end;

// CollectInteger
//
function TStringIterator.CollectInteger : Int64;
var
   neg : Boolean;
begin
   if (FPosition<FLength) and (FPStr[FPosition]='-') then begin
      neg:=True;
      Inc(FPosition);
   end else neg:=False;
   if FPosition>=FLength then
      EStringIterator.Create('Unfinished integer');
   Result:=0;
   while FPosition<FLength do begin
      case FPstr[FPosition] of
         '0'..'9' : begin
            Result:=Result*10+Ord(FPstr[FPosition])-Ord('0');
            Inc(FPosition);
         end;
      else
         break;
      end;
   end;
   if neg then
      Result:=-Result;
end;

// CollectFloat
//
function TStringIterator.CollectFloat(var value : Double) : Boolean;
begin
   var start := FPosition;
   while FPosition < FLength do begin
      case FPstr[FPosition] of
         '0'..'9', '.', 'e', '+', '-' : Inc(FPosition);
      else
         Break;
      end;
   end;
   if start = FPosition then Exit(False);

   Result := TryStrToDouble(@FPStr[start], value);
end;

end.
