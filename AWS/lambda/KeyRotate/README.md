## Build Package

### Start Rancher
Start Rancher or other container management tool.

### Create a Image
 Using your favorite editor, create a **Dockerfile** with the contents, note that the version of python may differ to what you need, so [double check](https://gallery.ecr.aws/lambda/python)
 
```
FROM public.ecr.aws/lambda/python:3.9

RUN yum -y install zip && yum -y clean all  && rm -rf /var/cache

ENTRYPOINT ["/bin/bash"]
```

Once you have your Dockerfile you need to build an image.

``` docker build . -t lambda ```

### Start your Docker image
In your code directory: 

```docker run -v ${PWD}:/lambda -it --rm lambda```


### Install modules

If you have a requirements.txt file then you can issue the command 

```
cd /lambda
pip install -t ./package -r requirements.txt
``` 

otherwise you will need to install each required module individually using 

```
cd /lambda
pip install -t ./package <module>
```

### Build your package

```
cd package
zip -r ../name_of_deployment_package .
cd ..
zip -g name_of_deployment_package.zip <local>.py <local>.py. ## Add all your Py files
```
