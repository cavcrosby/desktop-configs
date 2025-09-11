#!/usr/bin/env node
// Syncs the Firefox preferences from the prefs.js file with what's in the
// user.js file.

import fs from 'fs';
import process from 'process';
import vm from 'vm';

const sandbox = {
  pref: (name, value) => record('pref', name, value),
  user_pref: (name, value) => record('user_pref', name, value),
  sticky_pref: (name, value) => record('sticky_pref', name, value),
  lockPref: (name, value) => record('lockPref', name, value),
};

function record(method, name, value) {
  calls.push({ method, name, value });
}

function serialize(call) {
  let value;
  switch (typeof call.value) {
    case 'string':
      value = `'${call.value}'`; // matches user.js quote style
      break;
    default:
      value = call.value;
  }

  return `${call.method}('${call.name}', ${value});`;
}

let calls = [];
vm.createContext(sandbox);
vm.runInContext(
  fs.readFileSync('./src/firefox/1m544c8z.default-release/user.js', 'utf8'),
  sandbox,
);

const userContentCalls = structuredClone(calls);
calls = [];
vm.runInContext(
  fs.readFileSync(
    `${process.env.HOME}/.mozilla/firefox/1m544c8z.default-release/prefs.js`,
    'utf8',
  ),
  sandbox,
);

calls = userContentCalls.map((userContentCall) => {
  let call = calls.find((call) => call.name === userContentCall.name);
  if (call != null) {
    return call;
  }
});

fs.writeFileSync(
  './src/firefox/1m544c8z.default-release/user.js',
  calls.map(serialize).join('\n') + '\n',
  'utf8',
);
