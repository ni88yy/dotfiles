#!/bin/sh
  exec scala -feature "$0" "$@"
!#
import java.nio.file._
import scala.collection.JavaConversions._
import scala.sys._
import scala.sys.process._

// set up the user and current directory
val homeDirPath = Paths.get(props("user.home"))
val currDirPath = Paths.get(props("user.dir"))

// get the link files directory
require(args.length == 0 || args.length == 1)
val dotFilesPath = if(args.length == 0) currDirPath else Paths.get(args(0))
require(Files.isDirectory(dotFilesPath))

// get the link files
val ds = Files.newDirectoryStream(dotFilesPath, "*.link")
val linkFilePaths = ds.map(_.toRealPath()).toList
require(linkFilePaths.length > 0)

// print summary of action
val destPath = Paths.get(homeDirPath.toString).toRealPath()
require(Files.isDirectory(destPath))
// println(s"""Creating symbolic links into ${destPath} for each link file: \n${linkFilePaths.mkString("\n")}\n""")

// perform the linkage
for(linkFilePath <- linkFilePaths) {
  val dotFileName = "." + linkFilePath.getFileName.toString.stripSuffix(".link")
  val dotFilePath = Paths.get(destPath.toString, dotFileName)
  if(Files.isSymbolicLink(dotFilePath)) {
    println(s"$dotFilePath symbolic link already exists. No-op.")
  } else if(Files.exists(dotFilePath)) {
    println(s"$dotFilePath file already exists. No-op.")
  } else {
    Files.createSymbolicLink(dotFilePath, linkFilePath)
    println(s"Created symbolic link $dotFilePath referes to $linkFilePath")
  }
}
