# New Day
Un'app che ti permette di ricevere la giusta carica per affrontare la giornata. Tutto ciò che vedi l'ho sviluppato io e in futuro spero di creare applicazioni più complesse. Questo è un mio primo progetto.
## Configurazione dell'ambiente
L'app è stata sviluppata in flutter, utilizzando la versione **3.10** di Dart. L'IDE che consiglio è Intellij, poiché permette di usare sia i simulatori Android che iOS per testare.
## Configurazione delle dipendenze
L'app per poter funzionare ha bisogno di alcune risorse esterne. Di seguito elenco quelle utilizzate:
- **flutter pub add flutter_dotenv**, per gestire le chiavi segrete nei file .env
- **flutter pub add google_generative_ai**, per abilitare Gemini lite
- **flutter pub add intl**, per cambiare la visualizzazione della data in DD-MM-AAAA
- Se dovessero esserci dei problemi generali, eseguire **flutter pub get**
## Creazione del file .ipa
Nota importante: questa procedura richiede un mac poiché supporta la compliazione Xcode. Per Windows non mi sono documentato sulla procedura.\
Detto questo, per poter creare l'eseguibile iOS (.ipa) occorre creare la build eseguendo questi comandi:
- **flutter clean**, rimuove file vecchi
- **flutter pub get**, ripristina le dipendenze
- **flutter build ipa --no-codesign --release**, crea il file .ipa\
Ora che Il file è stato creato bisogna creare il pacchetto completo. Da adesso in poi sono comandi bash:
- **cd build/ios/archive/Runner.xcarchive/Products/Applications/**
- **mkdir Payload**, creazione della cartella Payload (**importantissima**)
- **cp -r Runner.app Payload/**, copia nella cartella Payload
- **zip -r -y PrimaApp.ipa Payload**, creazione finale del file
- **mv PrimaApp.ipa ~/Desktop/**, sposta il file su Scrivania\
Se qualcosa non dovesse andare con la compilazione, probabilmente bisogna effettuare una modifica da Xcode per quanto riguarda il certificato.\
Basta seguire questi passaggi:
- - Aprire Xcode con il comando: **open ios/Runner.xcworkspace**
- - Selezionare **Runner** (icona blu a sinistra). 
- - Sotto la voce **TARGETS** selezionare **Runner**.
- - Nel tab **General**, modificare il **BundleIdentifier**(es. com.x.y).
- - Chiudere Xcode.
## Creazione APK
Al contrario del file .ipa, .apk può crearlo qualsiasi sistema operativo. Il comando da eseguire è:
- **flutter build apk --release**\
Verrà creata l'apk nel percorso **build/app/outputs/flutter-apk/app-release.apk**