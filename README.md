Минимальный и воспроизводимый проект для обхода DPI с помощью zapret (nfqws).
Конфигурация ориентирована на YouTube и проверена в реальной сети с блокировками.

Поддерживается работа через WireGuard (wg0) и обычный интерфейс хоста.

────────────────────────────────

УСТАНОВКА (ONE-CLICK)

Клонировать репозиторий:

git clone git@github.com
:AndreyShatl/zapret_test.git
cd zapret_test

Запустить установку:

sudo ./install.sh

────────────────────────────────

ЧТО ДЕЛАЕТ install.sh

• Устанавливает зависимости (nftables, curl, ca-certificates)
• Создаёт /etc/zapret
• Копирует рабочий yt-tcp.conf и youtube.txt
• Устанавливает nftables-таблицу zapret
• Включает и запускает сервис zapret-nfqws@yt-tcp
• Не ломает существующий firewall

────────────────────────────────

ПРОВЕРКА РАБОТЫ

Статус сервиса:

systemctl status zapret-nfqws@yt-tcp

Проверка nftables:

nft list table inet zapret

Если YouTube открывается и видео воспроизводится — всё работает корректно.

────────────────────────────────

ИСПОЛЬЗУЕМАЯ СТРАТЕГИЯ

Файл:
/etc/zapret/yt-tcp.conf

Используется стратегия fakedsplit с fooling=ts и split-pos=midsld.
Стратегия подобрана автоматически с помощью blockcheck.sh
и показала стабильную работу для YouTube.

────────────────────────────────

УДАЛЕНИЕ (ОТКАТ)

Для полного удаления конфигурации:

sudo ./uninstall.sh

Будут:
• остановлен сервис zapret-nfqws@yt-tcp
• удалены конфиги YouTube
• удалена nftables таблица zapret

────────────────────────────────

СТРУКТУРА ПРОЕКТА

zapret_test
├── install.sh
├── uninstall.sh
├── README.md
└── config
├── zapret
│ ├── yt-tcp.conf
│ └── youtube.txt
└── nftables
└── zapret.nft

────────────────────────────────

АВТОР

AndreyShatl
Email: stigshatl@gmail.com

────────────────────────────────

ПРИМЕЧАНИЕ

Проект намеренно минимален.
Без универсальных «магических» конфигов.
Только проверенная и рабочая схема, пригодная для переноса на любой хост.
