#ifndef IRRASSIMPUTILS
#define IRRASSIMPUTILS

#ifdef IRRASSIMP_BUILD
	#ifdef IRRASSIMP_STATIC
		#define IRRASSIMP_EXPORT __declspec(dllimport)
	#else
		#define IRRASSIMP_EXPORT __declspec(dllexport)
	#endif
#else
	#define IRRASSIMP_EXPORT
#endif

#include <IFileSystem.h>
#include <assimp/Logger.hpp>

IRRASSIMP_EXPORT aiString irrToAssimpPath(const irr::io::path& path);

#endif // IRRASSIMPUTILS
