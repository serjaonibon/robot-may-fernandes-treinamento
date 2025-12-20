import time
import sys

print("Hello Robotizador!!!")
print("Fechando em 5 segundos...")
for count in range(5):
    print(count+1)
    time.sleep(1)

sys.exit(0)  # Indica sucesso explicitamente
