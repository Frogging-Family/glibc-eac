# glibc-eac

**Update2: As of 2.39-1, DT_HASH reenabling was removed from the Arch package. While many games were patched, not all were. We have added the patch for it back for the affected games.**

**Update: As of https://github.com/archlinux/svntogit-packages/commit/e1d69d80d07494e3c086ee2c5458594d5261d2e4, Arch glibc will work again with eos-eac games, except for Rogue Company which needs additional reverts.
The approach used by Arch's glibc maintainer is the same as this (reverting the offending change), so updating to the 2.36-2 package will be totally seemless. Rogue Company players, I fear you'll have to keep using this package.**

Arch glibc with commits breaking eos-eac and Rogue Company patched out.

Run `./glibc_eac.sh` to build and install, or `./glic_eac.sh build` to only build.

Warhammer Vermintide 2 (Steam) - Newer eac
![Screenshot_20220808_171315](https://user-images.githubusercontent.com/741977/183456541-1ee77f9f-33e4-4066-81ac-fbcb32d1f58e.png)

Brawlhalla - eos-eac
![Screenshot_20220809_133230](https://user-images.githubusercontent.com/741977/183637384-842c0239-78d0-4fe5-afd9-8a7138bdf24f.png)

Rogue Company (Steam) - eos-eac (with a twist?)
![Screenshot_20220808_163238](https://user-images.githubusercontent.com/741977/183456573-be2ca774-524e-413a-b5d0-90e838637585.png)

Dauntless (EGS) - legacy eac - has other issues (stack smashing)
![Screenshot_20220808_174604](https://user-images.githubusercontent.com/741977/183458660-e3190107-3f45-40ad-a46e-8af691cb09c7.png)
