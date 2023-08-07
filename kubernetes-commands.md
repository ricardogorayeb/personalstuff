kubectl get nodes -o wide

kubectl rollout history deployment nginx-deployment --> pods history


kubectl annotate deploy nginx-deployment kubernetes.io/change-cause="imagem versao 1" --> annotate info about a pod change like image version


kubectl rollout undo deployment nginx-deployment --to-revision=2  --> roolback to a specific history version
