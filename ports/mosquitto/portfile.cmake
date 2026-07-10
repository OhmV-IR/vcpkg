vcpkg_from_github(
	    OUT_SOURCE_PATH SOURCE_PATH
	        REPO eclipse/mosquitto
		    HEAD_REF master
		        REF "v${VERSION}"
			    SHA512 eb850d61e401bb3afe97a32d1630d269eed2672baebbff87dc05fd4c33dd9c611c1e5714cf9b8beb0cca3536a134dcc9f5a19d14f2bc9f4819800a9cfb5fd81c
		    )
		    string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" STATIC_LINKAGE)

		    vcpkg_cmake_configure(
			        SOURCE_PATH "${SOURCE_PATH}"
				    OPTIONS
				            -DWITH_STATIC_LIBRARIES=${STATIC_LINKAGE}
					            -DWITH_SRV=OFF
						            -DWITH_TLS=ON
							            -DWITH_EDITLINE=OFF
								            -DWITH_WEBSOCKETS_BUILTIN=ON
									            -DWITH_SQLITE=ON
										            -DWITH_HTTP_API=ON
											            -DWITH_TLS_PSK=ON
												            -DWITH_THREADING=ON
													            -DDOCUMENTATION=OFF
														            -DWITH_PLUGINS=ON
															            -DWITH_CJSON=ON
																            -DWITH_CLIENTS=OFF
																	            -DWITH_APPS=OFF
																		            -DWITH_BROKER=ON
																			            -DWITH_BUNDLED_DEPS=ON
																				            -DWITH_DOCS=OFF
																					            -DWITH_TESTS=OFF
																					    )
																					    vcpkg_cmake_install()
																					    vcpkg_copy_pdbs()

																					    # ==============================================================================
																					    # --- WINDOWS BROKER FIX ---
																					    # Extract the stranded 'mosquitto_broker.lib' export file out of the build 
																					    # cache and copy the broker executable safely over to the tools directory.
																					    # ==============================================================================
																					    if(VCPKG_TARGET_IS_WINDOWS)
																						        # 1. Glob and harvest the compiled broker .lib files from the build tree
																							    file(GLOB_RECURSE RELEASE_BROKER_LIB "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/*mosquitto_broker.lib")
																							        if(RELEASE_BROKER_LIB)
																									        file(INSTALL ${RELEASE_BROKER_LIB} DESTINATION "${CURRENT_PACKAGES_DIR}/lib")
																										    endif()

																										        file(GLOB_RECURSE DEBUG_BROKER_LIB "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/*mosquitto_broker.lib")
																											    if(DEBUG_BROKER_LIB)
																												            file(INSTALL ${DEBUG_BROKER_LIB} DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib")
																													        endif()

																														    # 2. Relocate the broker executable to the tools directory to avoid vcpkg validation errors
																														        if(EXISTS "${CURRENT_PACKAGES_DIR}/sbin/mosquitto.exe")
																																        file(INSTALL "${CURRENT_PACKAGES_DIR}/sbin/mosquitto.exe" DESTINATION "${CURRENT_PACKAGES_DIR}/tools/${PORT}")
																																	    endif()

																																	        # 3. Clean up non-standard sbin folders entirely
																																		    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/sbin" "${CURRENT_PACKAGES_DIR}/debug/sbin")
																																	    endif()
																																	    # ==============================================================================

																																	    vcpkg_fixup_pkgconfig()

																																	    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
																																	    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
																																	    file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")

																																	    vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
