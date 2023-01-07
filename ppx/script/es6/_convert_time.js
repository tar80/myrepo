//!*script
/**
 * Convert time_T and FileTime to each other
 *
 * @arg 0 Specify format. time | dword
 * When time is specified. If arg(1) is empty, the current time is targeted.
 * @arg 1+ year, month, day, hours, minutes, seconds
 * When dword is specified.
 * @arg 1 dwordHIGH
 * @arg 2 dwordLow
 */

'use strict';

const EPOC_DIFF = 11644473600;

const tToFiletime = (dwHigh, dwLow) => {
  const sec = 1e-7 * (dwHigh * Math.pow(2, 32) + dwLow) - EPOC_DIFF;
  let date = new Date(0);
  date.setSeconds(sec);

  return date;
};

const filetimeToT = (year, month, day, ...time) => {
  const sec =
    time.length === 0 ? new Date().getTime() : new Date(year, month - 1, day, ...time).getTime();
  const dwHigh = (sec * 1e-3 + EPOC_DIFF) / 1e-7 / Math.pow(2, 32);
  const dwHigh_ = Math.floor(dwHigh);
  const dwLow = (dwHigh - dwHigh_) * Math.pow(2, 32);

  return [dwHigh_, dwLow];
};
