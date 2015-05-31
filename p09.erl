-module(p09).
-export([pack/1]).

pack([H|[]])->[H];

pack([[H|T1]|[H|T2]])->pack([[H|[H|T1]]|T2]);

pack([[H1|T1]|[H2|[]]])->[[H1|T1],[H2]];
pack([[H1|T1]|[H2|T2]])->[[H1|T1]|pack([H2|T2])];
pack([H|[H|T]])->pack([[H,H]|T]);
pack([H1|[H2|T]])->[[H1]|pack([H2|T])];

pack([])->[].