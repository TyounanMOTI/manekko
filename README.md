# manekko
OpenFrameworksと、KORGのWISTを使ってみた。

２台のiOSデバイス間で、拍子を同期するアプリ。
起動時は、バスドラムの音が二つのデバイスでズレている。
これをBluetooth経由で同期させる。

WISTでつながると、片方の円が赤くなる。
赤い方のデバイスをタップすると、緑の円が同期する。

ちなみに、緑の方のデバイスをタップすると、スネアの音が鳴る。

## 必要なもの
WIST library中の以下のファイル
- KorgWirelessSyncStart.h
- KorgWirelessSyncStart.m

あと、OpenFrameworks。

## LICENSE
following files are public domain.
- main.mm
- testApp.mm
- testApp.h
- WISTManekkoDelegate.h
- WISTManekkoDelegate.mm
- kick.caf (originally http://www.freesound.org/people/DWSD/sounds/171104/)

following item is not public domain
- tech_snare.caf
		CC by 3.0
		created by TwistedLemon
		http://www.freesound.org/people/TwistedLemon/sounds/2041/
