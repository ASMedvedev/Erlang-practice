-module(bs04).
-export([decode_xml/1]).


%BinXML = 
%		  <<"<start>  
%					  <item>  Text1  </item>  
%                     <item>  Text2  </item>
%         </start>">>.

%   <item>Text1</item>   <item>Text2</item>

decode_xml(BinXML) -> 
PosLen = binary:match(BinXML, [<<">">>],[]),
if
PosLen =/= nomatch ->
{PosEndofTagStart, _} = PosLen, %PosEndofTagStart, %6

TagStart = binary:part(BinXML,  {1,PosEndofTagStart-1}), %TagStart,        % name of the start tag

PosOfEndTag = binary:match(BinXML, << <<"/">>/binary, TagStart/binary >>, []), {PosStEndTag,LenEndTag} =  PosOfEndTag,    % name of the end tag  {44, 6}

Body = binary:part(BinXML,  {PosEndofTagStart+1, PosStEndTag-LenEndTag-2 }), %{TagStart , [] , [Body] }.

{TagStart , [] , [decode_xml(Body)] };

true -> BinXML
end.