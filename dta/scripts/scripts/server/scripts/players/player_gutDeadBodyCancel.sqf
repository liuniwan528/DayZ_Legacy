_user = _this;

_user setVariable ['inUseItem',objNull];
_user setVariable ['isUsingSomething',0];
_user setVariable ['wasCanceled',1];
[_user,'Current action was cancelled',''] call fnc_playerMessage;
_user playAction 'CancelAction';
(_user getVariable 'skinnedBody') setVariable['isBeingSkinned', nil];
_user setVariable ['skinnedBody',nil];