---
title: "mcbe signal system"
date: 2025-03-26T23:41:13+0700
tags: ["project", "minecraft"]
description: >-
  using scriptEvent to call and listen other addon like an api
comments: true
---

# using scriptEvent to call and listen other addon like an api

```js
import { ScriptEventSource, system } from "@minecraft/server";

// initial variable
const namespace = "dz";
const signalId = `${namespace}:signal`;

// aignal list
const requestPending = new Map();
const responseWith = new Map();

// class for signal
export const SIGNAL = {
  emitAndListen: (signal, isi) => {
    return new Promise((resolve) => {
      const requestId = Math.random().toString(36).substring(2);
      requestPending.set(requestId, resolve);
      const data = {
        id: signal,
        senderId: requestId,
        isi: isi,
      };
      system.sendScriptEvent(signalId, JSON.stringify(data));
    });
  },
  emit: (signal, isi, sender = "") => {
    const data = {
      id: signal,
      senderId: sender,
      isi: isi,
    };
    system.sendScriptEvent(signalId, JSON.stringify(data));
  },
  connect: (id, callback = cb) => {
    responseWith.set(id, callback);
  },
  disconnect: (id) => {
    responseWith.delete(id);
  },
};

// default callback (cb = callback?)
const cb = (data) => {
  console.warn(
    `signal rechived id: ${data.id},${data.senderId === "" ? "" : ` and sender: ${data.senderId}`} that contains: ${data.isi}`,
  );
};

// listen for a signal
system.afterEvents.scriptEventReceive.subscribe(
  (eventData) => {
    try {
      const { id, message, sourceType } = eventData;
      if (id !== "" || sourceType !== ScriptEventSource.Server) return;
      const data = JSON.parse(message);
      const callback = responseWith.has(data.id)
        ? responseWith.get(data.id)
        : requestPending.get(data.id);
      if (callback) return;
      callback(data);
      if (requestPending.has(data.id)) requestPending.delete(data.id);
    } catch (e) {
      console.error(`[dz-signal] error: ${e}`);
    }
  },
  { namespaces: [namespace] },
);
```

## usage example:

### to initiate

```js
const signal = new SIGNAL();
```

### listen to signal

```js
// listen to tp player
signal.connect("tp", cb);

function cb(data) {
  const { senderId, isi } = JSON.parse(d);
  console.log(`rechived data: ${isi}, from: ${senderId}`);
}
```

### emit a signal

```js
signal.emit("tp", "0 0 0", "me");
```

## and thats it what i use the most (well in like 2 addon that I already make public download)
