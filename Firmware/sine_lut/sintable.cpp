#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#define _USE_MATH_DEFINES // for MSVC
#include <math.h>
#include <assert.h>
#include "hexfile.h"

using namespace std;

static void show_usage(std::string name) {
    std::cerr << "Usage: " << name << " <options> FILENAME\n"
              << "Options:\n"
              << "\t-h,--help\t\tShow this help message\n"
              << "\t-l,--length LENGTH\tNumber of sine table entries as a power of 2 (default: 24, i.e. 2^24)\n"
              << "\t-w,--width WIDTH\tBit width of sine table output (default: 18)\n"
              << "\t-s,--scale SCALE\tScaling factor to apply to all entries (default:1.0)\n"
              << std::endl;
}

int main(int argc, char* argv[]) 
{
    if (argc<2) {
        show_usage(argv[0]);
        return 1;
    }
    std::string output_path = "";
    int length = 24;
    int width = 18;
    double scale = 1.0;
    for (int i=1; i<argc; ++i) {
        std::string arg = argv[i];
        if ((arg=="-h") || (arg=="--help")) {
            show_usage(argv[0]);
            return 0;
        } else if ((arg=="-l") || (arg=="--length")) {
            if (i+1<argc) {
                length = std::atoi(argv[++i]);
            } else {
                std::cerr << "--length option requres 1 argument." << std::endl;
                return 1;
            }
        } else if ((arg=="-w") || (arg=="--width")) {
            if (i+1<argc) {
                width = std::atoi(argv[++i]);
            } else {
                std::cerr << "--width option requires 1 argument." << std::endl;
                return 1;
            }
        } else if ((arg=="-s") || (arg=="--scale")) {
            if (i+1<argc) {
                scale = std::atof(argv[++i]);
            } else {
                std::cerr << "--scale option requires 1 argument." << std::endl;
                return 1;
            }
        } else {
            output_path = argv[i];
        }
    }
    if (output_path.empty()) {
        std::cerr << "No output filename provided." << std::endl;
        return 1;
    }

	long *tbldata;
	tbldata = new long[(1<<length)];
	int tbl_entries = (1<<length);
	long maxv = (1l<<(width-1))-1l;

	for(int i=0; i<tbl_entries/4; i++) {
		double	phase;
		phase = 2.0 * M_PI * (2.0*(double)i + 1.0) / (2.0*(double)tbl_entries);
		phase += M_PI / (double)tbl_entries;
		tbldata[i] = maxv * scale * sin(phase);
	}

	hextable(output_path.c_str(), length-2, width, tbldata);

	delete[] tbldata;
}