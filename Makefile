BINARY_NAME=c_ipam
DOCKERHUB_ID=lpfi
IMAGE_NAME=$(DOCKERHUB_ID)/$(BINARY_NAME)

test:
	rspec

image:
	docker build --force-rm -t $(IMAGE_NAME) .

clean:
	rm -f $(BINARY_NAME)

clean-images:
	docker rmi -f $(IMAGE_NAME)

clean-all: clean clean-images
