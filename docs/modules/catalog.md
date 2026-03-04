# Modul Catalog - Tvorba Controlleru

V této části si ukážeme, jak v modulu **Catalog** vytvořit standardní administrační kontroler. Kontrolery v tomto CMS (Glow) silně využívají systém **Streams** pro definici datových polí, generování formulářů a výpisů.

## Základní struktura Controlleru

Administrační kontroler by měl dědit od `App\Controllers\AdminController` a nacházet se ve jmenném prostoru modulu, např. `Glow\Catalog\Controllers`.

```php
<?php

namespace Glow\Catalog\Controllers;

use App\Controllers\AdminController;
use Glow\StreamFields\Libraries\StreamsManager;
use Glow\StreamFields\Libraries\FormManager;
use Glow\StreamElements\Libraries\Form\Form;
use Glow\Streams\Libraries\StreamContentCard;
use Glow\Streams\Libraries\StreamContentTabs;

class AdminExample extends AdminController
{
    public function __construct()
    {
        parent::__construct();
    }
    
    // Zde budou metody index, add, edit, delete...
}
```

## 1. Zobrazení přehledu a filtrace (metoda `index` a list)

Přehled záznamů obvykle obsahuje filtr a tabulku (seznam karet nebo řádků). K sestavení layoutu (UI) používáme `StreamContentCard` a `StreamContentTabs`. Samotná data do tabulky se následně donačítají přes AJAX v další metodě.

```php
use Glow\Catalog\Models\ExampleFilter; // Váš model pro daný stream
use Glow\UI\UICard;

public function index()
{
    $model = new ExampleFilter();
    $getFilterElements = $model->getFilterElements();

    // 1. Vytvoření tabů (pro možnost rozčlenění složitějších přehledů)
    $tabs = new StreamContentTabs('example_tab_id');
    $tabs->newTab('Přehled', 'admin/example', true);
    
    // 2. Přidání filtrovacích prvků do záhlaví
    $tabs->filterElement($getFilterElements);
    $tabs->filterLineEnd();
    
    // 3. Inicializace AJAX filtru s ID budoucí karty, do které se načtou data
    $tabs->jsFilterList('exampleCard')->load();

    // 4. Vytvoření hlavní obalové karty
    $card = new StreamContentCard('exampleCard');
    $card->setHeader(
        UICard::make()->header('Přehled záznamů')
            ->addSearch('admin/example') // URL konektoru pro vyhledávání
    );
    
    $card->stageContent($tabs);
    $card->stageLineEnd();

    // Vyrendrování šablony sekce v administraci
    return admin()->stringToSection($card->view())->render();
}
```

### AJAX metoda pro načtení dat
Pro vrácení dat tabulky, kterou si CMS zavolá AJAXem, definujeme další metodu (např. `listData`). Pro naformátování výsledků použijeme `AppTable` obalující `StreamList`.

```php
use Glow\StreamFields\Libraries\List\StreamList;
use Glow\StreamElements\Libraries\List\AppTable;

public function listData()
{
    $model = new ExampleFilter();
    
    // Definujeme dotaz včetně filtrů s využitím napojeného modelu
    $model->listQuery()
        ->filter($this->request)
        ->orderBy($model->getTable() . '.updated_at desc');

    // Inicializace handleru listu z modelu (včetně paginace)
    $list = new StreamList($model, $model->getPerPage());
    
    // (Volitelné) Zapojení custom formátovací třídy pro konkrétní zobrazení v UI
    // $list = (new UIExampleList)->layout($list, 'stream_slug');

    // Obalení listu do HTML tabulky pro frontend
    $applist = new AppTable($list);

    // Návrat ve formátu JSON, který předpokládá frontendové API
    return $this->response->setJSON([
        'status' => 'success',
        'message' => '',
        'data' => $applist->view()
    ]);
}
```

## 2. Přidání a Editace záznamu (metody `add` a `edit`)

Zpracování formulářů funguje plně pod taktovkou entit `Stream`. K napojení poslouží `FormManager`, kterému předáme instanci `StreamsManager`. Modulární systém pak podle "SLUG" názvu automaticky poskládá formulářové pole. Tento formulář typicky rozdělujeme do tabů (`StreamContentTabs`) a políčka stavíme pomocí pomocných (protected) metod.

### Metoda `add`

```php
public function add()
{
    $slug = 'catalog_example'; // Název streamu v databázi např. 'catalog_products'
    
    // Práce s konfigrovaným streamem polí
    $StreamsManager = new StreamsManager();
    $stream = $StreamsManager->getStream($slug);

    $card = new StreamContentCard('StreamsCard');
    $card->header()->title('Nový záznam');

    // Inicializace správce pro zápis z formuláře
    $formManager = new FormManager(new Form(), $StreamsManager);
    $form = $card->form($formManager); // formBody, formFilter
    $form->setDefaultButtons(); // Automaticky vygeneruje tlačítka Uložit, Zpět atd.

    // Rozdělení rozsáhlého obsahu formuláře na Taby
    $tabs = new StreamContentTabs('example_form', $formManager);
    $tabs->tabsContent()->addClass('mt-4');

    // Přidání prvního Tabu
    $tabs->newTab('Hlavní údaje');
    $tabs = $this->buildMainTab($tabs, $slug);

    // Přidání druhého Tabu
    $tabs->newTab('Podrobnosti');
    $tabs = $this->buildDetailTab($tabs, $slug);

    // Napojení kontejneru na kartu
    $card->stageContent($tabs);

    // Zpracování odeslání (Automatické uložení a validace dle typu jednotlivých Fields v DB)
    if ($form->save()) {
        service('alerts')->add('success', 'Uloženo');
        $result = $stream->getResult();
        
        // Přesměrování na režim editace u čerstvě vytvořeného záznamu
        return $form->redirect('admin/example/edit/' . $result->id);
    }

    // Vykreslení UI pro prázdný formulář (příprava šablony)
    return admin()->stringToSection($card->view())->render();
}
```

### Metoda `edit`

Metoda `edit` je prakticky shodná s metodou `add`, kromě nutnosti na začátku naplnit Stream daty existujícího záznamu pomocí `$stream->setEntryId($id)`. Modul pak provede fetch z databáze a pole formulářů automaticky předvyplní příslušnými hodnotami.

```php
public function edit($id)
{
    $slug = 'catalog_example';
    
    $StreamsManager = new StreamsManager();
    $stream = $StreamsManager->getStream($slug);
    
    // Klíčový krok: Napojení konkrétního ID záznamu
    $stream->setEntryId($id);

    $card = new StreamContentCard('StreamsCard');
    $card->header()->title('Úprava záznamu');

    $formManager = new FormManager(new Form(), $StreamsManager);
    $form = $card->form($formManager);
    $form->setDefaultButtons();

    $tabs = new StreamContentTabs('example_form', $formManager);
    $tabs->tabsContent()->addClass('mt-4');

    $tabs->newTab('Hlavní údaje');
    $tabs = $this->buildMainTab($tabs, $slug);

    $card->stageContent($tabs);

    // Stejný princip pro validaci a Update modifikovaného záznamu
    if ($form->save()) {
        service('alerts')->add('success', 'Úpravy uloženy');
        
        // Reload aktuální stránky pro propsání změn
        return $form->redirect('admin/example/edit/' . $id);
    }

    return admin()->stringToSection($card->view())->render();
}
```

### Pomocné metody pro sestavování polí (`buildMainTab` a další)

Pro přehlednost kódu se vykreslení příslušných formulářových polí rozděluje na metody podle Tabů. Použitím `stageField()` říkáme, která pole ze streamu a v jakém pořadí se mají objevit na stránce.

Lze u nich měnit šířku kontejneru a implementovat callbacky pro nestandardní chování (jako AJAX vyhledávání a párování u cizích klíčů).

```php
use Glow\Catalog\Components\Admin\SelectSupplier;

protected function buildMainTab(StreamContentTabs $card, string $slug): StreamContentTabs
{
    // Vyrendruje pole 'code' ze streamu nastavené na šířku 2 bootstap sloupců
    $card->stageField($slug, 'code')->colWidth(2);
    
    // Vyrendruje systémové pole 'name' podle definice ve streamu, šířku dopočítá do 12 bootstrap sloupců
    $card->stageField($slug, 'name');
    
    // Ukončení řádku (Odentruje a další field hodí na nový "HTML řádek")
    $card->stageLineEnd();

    // Ukázka přidání pole reprezentující relaci ('supplier_id') 
    // Místo obyčejného select boxu voláme vlastní 'Select' komponentu s vyhledávačem dodavatelů
    $card->stageField($slug, 'supplier_id')->setCallback(function ($item, $rowData) {
        (new SelectSupplier())->find($item, $rowData);
    });
    
    $card->stageLineEnd();
    
    $card->stageLineEnd();
    
    // Dlouhé textové pole 'description' - automaticky přidělí WYSIWYG nebo běžnou textareu
    $card->stageField($slug, 'description');
    $card->stageLineEnd();

    return $card;
}
```

### Standardní pole vs. Vlastní komponenty (Overrides)

Systém `StreamFields` řeší přes vnitřní knihovny automatické vykreslování běžných polí např. `RelationType`.

Pokud v databázi u pole *Streamu* s názvem `type_id` nadefinujete vlastnosti propojení (např. *relationTable* = `products_types`, *titleField* = `name`), systém sám dokáže takové pole vyrenderovat a naplnit ho daty z číselníku. V Controlleru by stačilo napsat:
```php
$card->stageField($slug, 'type_id');
```

**Kdy použít `setCallback` a Vlastní komponenty (Custom Components)?**
V případech, kdy výchozí databázová automatika nedostačuje a je nutné vložit proprietární business logiku, využíváme v controleru metodu `setCallback` k delegaci úkolu na Vlastní komponentu (viz příklad výše `$card->stageField($slug, 'supplier_id')->setCallback(...)`). 

Případy užití vlastních komponent:
1. **Složitá business logika:** Potřebujeme omezit seznam položek podle oprávnění přihlášeného administrátora, případně podle stavu jiných položek ve formuláři.
2. **AJAX (Lazy loading):** Pokud tabulka relací obsahuje desetitisíce záznamů (např. `users`, `products_variants`), standardní načtení by zablokovalo výkon prohlížeče. Komponenta může řešit vyhledávání prostřednictvím asynchronního AJAX dotazu.
3. **Kompozitní form prvky:** Místo jednoduchého `Select` pole potřebujeme renderovat komplexní výběr (např. otevírací modální okno s gridem pro výběr více položek s náhledy obrázků).

## 3. Mazání záznamů (metoda `delete`)

Smazání záznamu musí vždy probíhat přes `StreamsManager` namísto nativních databázových Builderů. Zajistíte tak čistý stav (odstranění příloh, pročištění vazeb generovaných streamovým modulem).

```php
public function delete($id)
{
    $slug = 'catalog_example';

    $StreamsManager = new StreamsManager();
    $stream = $StreamsManager->getStream($slug);
    
    // Nastavíme ID smazávaného záznamu
    $stream->setEntryId($id);

    // Spustíme logiku odstranění všech prvků asociovaných se streamem
    if ($stream->delete()) {
        service('alerts')->add('success', 'Záznam byl úspěšně smazán');
    } else {
        service('alerts')->add('danger', 'Záznam se nepodařilo smazat');
    }

    // Přesměrování zpět na přehled tabulky
    return redirect()->to('admin/example');
}
```

### Další možnosti Controlleru

Komplexní moduly se silnými datovými vazbami (jako `AdminProducts`) řeší skrze tabulkový systém implementaci celých samostatných iframe-zobrazení pro správu Ceníků a Variací na úrovni detailu položky. V takových případech se `edit` metoda rozšiřuje o předání `productId` dalším protected metodám, které renderují vnořené list-view layouty.
