all:
	mkdir -p /home/bde-la-p/data/db
	mkdir -p /home/bde-la-p/data/wp
	docker-compose -f srcs/docker-compose.yml up --build

down:
	docker-compose -f srcs/docker-compose.yml down

re:
	$(MAKE) down
	$(MAKE) all

clean:
	docker system prune -af

fclean: clean
	su -c "rm -rf /home/bde-la-p/data/db /home/bde-la-p/data/wp"

.PHONY: all down re clean fclean