## Memtest для 32-х битных х86 машин и Makefile для автоматического запуска

### Зависимости

*  bash
*  make
*  nasm
*  VirtualBox (c)
*  bc
*  ImageMagick (c)

Для запуска проекта необходимо, чтобы в VirtualBox была зарегистрирована машина
с именем `mipt_os_test` без жесткого диска и с одним floppy приводом

### Возможности автоматической проверяющей системы

Проверяющая система, основанная на возможностях утилиты `make` обладает
следующими возможностями:

*  Создание образа операционной системы: `make img`
*  Запуск виртуальной машины `make vm_start`
*  Запуск виртуальной машины с собранным образом: `make vm_load`
*  Получение скриншота с виртуальной машины: `make vm_screenshot`
*  Запуск автоматического тестирования на основе сравнения
	   скриншотов: `make test`

*Работа со скриншотами реализована в данный момент не очень верно и требует
рефакторинга*

### Проверяющий скрипт

Проверка корректности результата происходит на базе утилиты `compare` идущей
в пакете `ImageMagick`.  Проверка происходит по метрике NCC (Normailzed Cross
Corelation)

### Функции в os.asm

#### memtest
Функция проверяет память. Имеет два аргумента:

`memtest(start_addr, end_addr)`

Фиксированное значение записывается в память во все адреса от `start_addr` до
`end_addr` (возможно, больше на 3 байта, так как записываются блоки по 4 байта).
В следующем цикле эти значения считываются и проверяются.  В зависимости от
результата (все да / хотя бы один нет) выводится соответствующее сообщение.

#### kputs

`kputs(char* str, char color)`

Записывает строку из первого аргумента в видеопамять, в качестве цвета
используется второй аргумент.

