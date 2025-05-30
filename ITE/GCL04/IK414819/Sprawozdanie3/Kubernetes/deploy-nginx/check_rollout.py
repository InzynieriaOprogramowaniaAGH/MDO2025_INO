import subprocess
import time

DEPLOYMENT_NAME = "igor-nginx"
TIMEOUT = 60

start_time = time.time()

print(f"🔍 Sprawdzanie rolloutu dla deploymentu: {DEPLOYMENT_NAME}")

while (time.time() - start_time) < TIMEOUT:
    try:
        result = subprocess.run(
            ["kubectl", "rollout", "status", "deployment", DEPLOYMENT_NAME],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        output = result.stdout.strip()
        print(output)

        if "successfully rolled out" in output:
            duration = round(time.time() - start_time)
            print(f"✅ Deployment zakończony sukcesem po {duration} sekundach")
            exit(0)

    except Exception as e:
        print(f"Błąd: {e}")

    time.sleep(1)

print(f"❌ Deployment NIE zakończył się w ciągu {TIMEOUT} sekund")
exit(1)
