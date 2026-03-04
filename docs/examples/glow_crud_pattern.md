# Tvorba Controlleru - Glow CRUD Pattern

V tradičním pojetí webových frameworků kontrolery přijímají data, manuálně je validují, zpracovávají přes různé služby a nakonec píší SQL dotazy (nebo volají modely) pro uložení.

**Glow CMS na to jde jinak.** Díky systému **Streams**, třídám `StreamsManager` a `FormManager` se Controller stává pouhým "režisérem", který deklaruje, **co** se má zobrazit. O validaci, vykreslení HTML a samotné uložení do databáze se stará jádro.

## 1. Tenký Controller (Deklarativní přístup)

Ukázka standardní metody `add()` (přidání nového záznamu) v administraci Glow. Všimněte si, že zde není žádné ruční čtení z `$_POST`, ani žádné `Model->insert()`.

`glow/Modules/Catalog/Controllers/AdminProducts.php`

```php
<?php

namespace Glow\Catalog\Controllers;

use App\Controllers\AdminController;
use Glow\StreamFields\Libraries\StreamsManager;
use Glow\StreamFields\Libraries\FormManager;
use Glow\StreamElements\Libraries\Form\Form;
use Glow\Streams\Libraries\StreamContentCard;
use Glow\Streams\Libraries\StreamContentTabs;
use Glow\Catalog\Components\Admin\SelectSupplier;

class AdminProducts extends AdminController
{
    private string $streamSlug = 'catalog_products';

    public function add()
    {
        // 1. Inicializace manažerů pro konkrétní Stream (databázovou tabulku)
        $StreamsManager = new StreamsManager();
        $stream = $StreamsManager->getStream($this->streamSlug);

        // 2. Vytvoření hlavní UI obálky (Karta)
        $card = new StreamContentCard('productCard');
        $card->header()->title('Nový produkt');

        // 3. Propojení Karty a Formuláře
        $formManager = new FormManager(new Form(), $StreamsManager);
        $form = $card->form($formManager); // Obalí kartu tagem <form>
        $form->setDefaultButtons(); // Automaticky rendering tlačítek (Uložit, Zpět)

        // 4. Sestavení vnitřního rozložení (Taby)
        $tabs = new StreamContentTabs('productTabs', $formManager);
        $tabs->tabsContent()->addClass('mt-4'); // Margin pro vzhled
        $tabs->newTab('Hlavní údaje');

        // --- DEKLARACE POLÍ ---
        
        // Běžná pole - systém sám pozná (dle DB), zda jde o Input, Textarea, Checkbox
        $tabs->stageField($this->streamSlug, 'code')->colWidth(4);
        $tabs->stageField($this->streamSlug, 'name'); // šířka se sama dopočítá
        $tabs->stageLineEnd(); // Nový HTML řádek v gridu
        
        $tabs->stageField($this->streamSlug, 'base_price');
        $tabs->stageLineEnd();

        // Pole se specifickou logikou / Vlastní komponentou (Callback)
        // Místo obyčejného selectu použijeme naši specializovanou komponentu SelectSupplier
        $tabs->stageField($this->streamSlug, 'supplier_id')->setCallback(function ($item, $rowData) {
            (new SelectSupplier())->find($item, $rowData);
        });
        $tabs->stageLineEnd();

        // 5. Vložení Tabů do hlavní Karty
        $card->stageContent($tabs);

        // --- ZPRACOVÁNÍ FORMULÁŘE ---
        // $form->save() automaticky detekuje POST, zvaliduje data dle metadat z DB a uloží je.
        if ($form->save()) {
            service('alerts')->add('success', 'Produkt byl úspěšně vytvořen.');
            
            // Získání ID nově vytvořeného záznamu pro přesměrování do editace
            $result = $stream->getResult();
            return $form->redirect('admin/products/edit/' . $result->id);
        }

        // --- VYKRESLENÍ UI ---
        // Pokud nedošlo k POST požadavku, nebo validace selhala, vykreslí se šablona
        return admin()->setTitle('Nový produkt')
                      ->addSection($card->view())
                      ->render();
    }
}
```

## 2. Kam umístit Byznys Logiku?

Protože Controller je tenký a `FormManager->save()` dělá vše automaticky, kam napíšeme složitou logiku (např. automatický přepočet ceny zboží, nebo integraci na cizí API)?

### A. Formatování a úprava dat: Vlastní `FieldType`
Pokud nějaké pole vyžaduje nestandardní uložení (např. `Decimal` částky formátované s čárkou, převedení pole do JSONu), řešíme to vytvořením **FieldType** třídy a implementací hooků `preOutput()` (před zobrazením) a `preSave()` (před uložením do DB). Controller se tak o tomto formátování vůbec nedozví.

### B. Speciální UI prvky: `Komponenty` (Components) a `setCallback`
Pokud potřebujeme vykreslit složitý element (např. AJAX vyhledávač napojený na externí tabulku), vytvoříme samostatnou třídu (Component). V Controlleru do gridu umístíme pole, ale použijeme `setCallback`, který deleguje zobrazení na tuto novou oddělenou třídu. Příklad viz `$tabs->stageField('..', 'supplier_id')->setCallback(...)` ve kódu výše.

### C. Návazné akce: `Events` (Události) v Modelech
Pokud přidání nového produktu vyžaduje smazání cache nebo synchronizaci s ERP systémem, ideálním místem pro volání služeb (Services / Adapters) jsou **Záchytné body (Callbacks) v CI4 Modelu**, konkrétně `afterInsert` a `afterUpdate` nebo přes `Events::trigger()`. To zajišťuje, že se akce provede nezávisle na tom, zda byl záznam vytvořen přes UI, nebo přes API import, a Controller zůstane opět čistý.

