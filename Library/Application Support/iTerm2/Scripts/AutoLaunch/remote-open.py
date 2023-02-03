#!/usr/bin/env python3.7

import asyncio
import iterm2
import os

async def main(connection):
    with open(os.path.expanduser('~/.config/iterm/remote-open-cookie')) as f:
        cookie = f.read().strip()
    print("Cookie is", cookie)
    async with iterm2.CustomControlSequenceMonitor(connection, cookie, r'^open +(.*)$') as mon:
        while True:
            match = await mon.async_get()
            await asyncio.create_subprocess_exec("/usr/bin/open", match.group(1))

# This instructs the script to run the "main" coroutine and to keep running even after it returns.
iterm2.run_forever(main)
