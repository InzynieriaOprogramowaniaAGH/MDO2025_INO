
#include <stdio.h>
#include "cJSON.h"

int main() {

    cJSON *user = cJSON_CreateObject();
    cJSON_AddStringToObject(user, "username", "CI_User");
    cJSON_AddNumberToObject(user, "build", 1025);

    char *json_str = cJSON_Print(user);
    if (json_str == NULL) {
        printf("Blad przy generowaniu JSON\n");
        cJSON_Delete(user);
        return 1;
    }

    printf("Wygenerowany JSON: %s\n", json_str);

    free(json_str);
    cJSON_Delete(user);

    return 0;
}
