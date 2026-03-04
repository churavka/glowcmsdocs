# Jak začít

Vítejte v dokumentaci **Glow CMS**. Tato příručka vás provede instalací a základním nastavením systému.

## Požadavky

Před instalací se ujistěte, že vaše prostředí splňuje následující požadavky:
*   PHP 8.1 nebo novější
*   Composer
*   Databáze (MySQL/MariaDB)

## Instalace

1.  **Stáhněte si projekt:**
    ```bash
    git clone https://github.com/vase-repo/glow-cms.git
    ```

2.  **Nainstalujte závislosti:**
    ```bash
    cd glow-cms
    composer install
    ```

3.  **Příprava DB kontextu pro AI:**
    Exportujte strukturu databáze do souboru, aby asistent rozuměl vašim tabulkám:
    ```bash
    mysqldump -u root -p --no-data vase_databaze > doc/db/schema.sql
    ```

## Kam dál?

Po úspěšné instalaci doporučujeme prostudovat následující sekce:

*   [Moduly](modules/index.md) - Seznamte se s katalogem a správou uživatelů.
*   [Streams](streams/streams.md) - Pochopte, jak fungují datové toky a jejich elementy.
*   [API](api/index.md) - Propojte Glow CMS s externími aplikacemi.
