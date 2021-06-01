# Nerves Livebook Firmware

[![CircleCI](https://circleci.com/gh/fhunleth/nerves_livebook.svg?style=svg)](https://circleci.com/gh/fhunleth/nerves_livebook)

This Nerves Livebook firmware lets you try out the Govee H6001 Bluetooth LED
bulb with the https://github.com/axelson/govee library

Example bulb:
https://www.amazon.com/gp/product/B07CL2RMR7

This is based on https://github.com/fhunleth/nerves_livebook but the system has
been configured to be usable with https://github.com/blue-heron/blue_heron for
Bluetooth Low Energy (BLE) support.

## Prerequisites

To work through this tutorial, you'll need:

* `rpi3` - Raspberry Pi 3 B+

## Building the Firmware

Make sure you've followed the Nerves getting started guide
https://hexdocs.pm/nerves/installation.html and then run:

``` sh
export MIX_TARGET=rpi3
mix deps.get
mix firmware
```

Once that's done, you're ready to burn the firmware to the MicroSD card.

## Burning the Firmware

Navigate to the directory where you downloaded the firmware. Either `fwup` or
`etcher` can be used to burn the firmware.

To be clear, this formats your SD card, and you will *lose all data on the SD
card*. Make sure you're OK with that.

### `fwup`

You'll need to install `fwup` if you don't have it. On Mac, run `brew install
fwup`. For Linux and Windows, see the [fwup installation
instructions](https://github.com/fwup-home/fwup#installing).

```sh
$ fwup nerves_livebook_rpi0.fw
Use 15.84 GB memory card found at /dev/rdisk2? [y/N] y
```

Depending on your OS, you'll likely be asked to authenticate this action. Go
ahead and do so.

```console
|====================================| 100% (31.81 / 31.81) MB
Success!
Elapsed time: 3.595 s
```

Now you have Nerves ready to run on your device. Skip ahead to the next
section.

### `etcher`

Start [`etcher`](https://www.etcher.net/), point it to the zip file, and follow
the prompts:

![etcher screenshot](assets/etcher.png)

## Running the Firmware

Eject the SD card and insert it into the device that you're using. Power up and
connect the device with a USB cable. In the case of the `rpi0`, the MicroUSB
does both.

After the device boots, point your browser at http://nerves.local. The password
is "nerves".

![Livebook screenshot](assets/livebook.jpg)

Then open the samples/govee.livemd file and run the code in there.
