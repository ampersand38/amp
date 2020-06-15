#include "script_component.hpp"
/*
 * Author: Ampersand
 * Handles scroll
 *
 * Arguments:
 * Amount scrolled <NUMBER>
 *
 * Return Value:
 * Handled <BOOL>
 *
 * Example:
 * [1.2] call amp_slingload_fnc_HandleScrollWheel;
 *
 * Public: No
 */

params ["_scrollAmount"];

if (!amp_slingload_pfeh_running) exitWith {false};

private _unit = ACE_player;

// manual rig
if ((_unit getVariable ["amp_slingload_addLiftPointEH", -1]) > -1) exitWith {
    amp_slingload_pfeh_action = RIG_UP;
    true
};

// apex fitting
if ((_unit getVariable ["amp_slingload_apexFittingEH", -1]) > -1) exitWith {
    if (_scrollAmount > 0) then {
        amp_slingload_fittingOffset = 1 min (amp_slingload_fittingOffset + _scrollAmount * 0.15);
    } else {
        amp_slingload_fittingOffset = -0.5 max (amp_slingload_fittingOffset + _scrollAmount * 0.15);
    };

    private _af = _unit getVariable ["amp_slingload_heldFitting", objNull];
    _af attachTo [_unit, [0, 0.5, amp_slingload_fittingOffset], "head"];

    true
};

// adjust rigging
if ((_unit getVariable ["amp_slingload_adjustRiggingEH", -1]) > -1) exitWith {
    amp_slingload_pfeh_action = [RIG_UP, RIG_DN] select (_scrollAmount < 0);
    private _ropes = _unit getVariable ["amp_slingload_ropesBeingAdjusted", []];
    private _lengths = "";
    {
        if (!isNull _x ) then {
            ropeUnwind [_x, 1, _scrollAmount * 2.5 / 6, true];
            private _length = ropeLength _x;
            _x setVariable ["amp_slingload_ropeLength", _length, true];
            _lengths = format ["%1 %2m", _lengths, (_length toFixed 1)];
        };
    } forEach _ropes;
    hintSilent _lengths;
    true
};
