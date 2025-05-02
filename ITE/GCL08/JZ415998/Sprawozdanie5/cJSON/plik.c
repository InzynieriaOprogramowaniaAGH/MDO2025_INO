#include "cJSON.h"
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Tworzenie głównego obiektu JSON
    cJSON *root = cJSON_CreateObject();

    // Dodanie stringa i liczby
    cJSON_AddStringToObject(root, "status", "ok");
    cJSON_AddNumberToObject(root, "code", 200);

    // Tworzenie tablicy
    cJSON *array = cJSON_CreateArray();
    cJSON_AddItemToArray(array, cJSON_CreateString("apple"));
    cJSON_AddItemToArray(array, cJSON_CreateString("banana"));
    cJSON_AddItemToArray(array, cJSON_CreateString("cherry"));

    // Dodanie tablicy do głównego obiektu
    cJSON_AddItemToObject(root, "fruits", array);

    // Konwersja obiektu do tekstu i wypisanie
    char *json_text = cJSON_Print(root);
    if (json_text) {
        printf("Serialized JSON:\n%s\n\n", json_text);
    }

    // Parsowanie z powrotem do obiektu
    cJSON *parsed = cJSON_Parse(json_text);
    if (!parsed) {
        fprintf(stderr, "Failed to parse JSON\n");
        free(json_text);
        cJSON_Delete(root);
        return 1;
    }

    // Wydobywanie elementów
    const cJSON *status = cJSON_GetObjectItem(parsed, "status");
    const cJSON *code = cJSON_GetObjectItem(parsed, "code");
    const cJSON *fruits = cJSON_GetObjectItem(parsed, "fruits");

    printf("Parsed data:\n");
    if (cJSON_IsString(status)) {
        printf("status: %s\n", status->valuestring);
    }
    if (cJSON_IsNumber(code)) {
        printf("code: %d\n", code->valueint);
    }
    if (cJSON_IsArray(fruits)) {
        printf("fruits:\n");
        cJSON *fruit = NULL;
        cJSON_ArrayForEach(fruit, fruits) {
            if (cJSON_IsString(fruit)) {
                printf(" - %s\n", fruit->valuestring);
            }
        }
    }

    // Sprzątanie
    free(json_text);
    cJSON_Delete(root);
    cJSON_Delete(parsed);
    return 0;
}
