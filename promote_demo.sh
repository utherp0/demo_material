echo "[CREATING DEVELOPMENT PROJECT AND APPLICATION]"
oc new-project dev1 --display-name="Development Area" --description="Development Area"
oc new-app registry.access.redhat.com/rhscl/nodejs-8-rhel7~https://github.com/utherp0/nodejs-ex --name="nodetest" -n dev1
oc expose svc/nodetest -n dev1

echo "[SLEEPING FOR 30 SECONDS TO ALLOW APP TO START]"
sleep 30

echo "[TAGGING A PRODUCTION IMAGE FOR USE]"
oc tag dev1/nodetest:latest dev1/nodetest:production

echo "[CREATING PRODUCTION PROJECT]"
oc new-project prod1 --display-name="Production Area" --description="Production Area"
oc adm policy add-role-to-user system:image-puller system:serviceaccount:prod1:default -n dev1
oc new-app dev1/nodetest:production --name="prodtest" -n prod1
oc expose svc/prodtest -n prod1
