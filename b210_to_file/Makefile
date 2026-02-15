all: rx_multi_samples

BUILDROOT=/t/buildroot-2021.11_RPi4/

rx_multi_samples: rx_multi_NISAR.cpp
	# $(BUILDROOT)/output/host/usr/bin/aarch64-buildroot-linux-gnu-g++ -Wall -O2 -o rx_multi_NISAR rx_multi_NISAR.cpp -luhd -lboost_program_options -lboost_system -lboost_thread -lboost_filesystem
	g++ -Wall -O2 -o rx_multi_NISAR rx_multi_NISAR.cpp -luhd -lboost_program_options -lboost_system -lboost_thread -lboost_filesystem

clean:
	rm *.o rx_multi_NISAR
