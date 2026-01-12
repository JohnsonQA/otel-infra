resource "kubernetes_storage_class_v1" "default" {
    metadata {
        name = "ebs-gp3"

        annotations = {
            "storageclass.kubernetes.io/is-default-class" = "true"
        }
    }

    storage_provisioner = "ebs.csi.aws.com"

    parameters = {
        type = "gp3"
        encrypted = "true"
    }

    reclaim_policy = "Delete" #means that when a PersistentVolumeClaim (PVC) using this StorageClass is deleted, the associated PersistentVolume (PV) will also be deleted, along with the underlying storage resource in AWS EBS.
    volume_binding_mode = "WaitForFirstConsumer" #This means that the actual provisioning of the storage volume will only occur when a pod that uses the PersistentVolumeClaim (PVC) is scheduled to run. This mode helps optimize resource allocation by ensuring that storage is only provisioned when it is actually needed by a pod.
    allow_volume_expansion = true
}