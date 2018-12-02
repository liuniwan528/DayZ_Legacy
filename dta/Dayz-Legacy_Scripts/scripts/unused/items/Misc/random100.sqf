_position = _this select 0;
_tiles = _this select 1;
_seed =floor((_position select 1) /_tiles)+floor((_position select 1) /_tiles)/10;
_seed = _seed % 10000000000;
_result = _seed ^ 2;
_result = _result * 654.189797;
_result = _result % 100;
_result