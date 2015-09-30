#!/bin/sh
  exec scala -feature "$0" "$@"
!#
import java.nio.file._
import scala.collection.JavaConversions._
import scala.sys._
import scala.sys.process._
import scala.util.Try

// set up the user and current directory
val homeDirPath = Paths.get(props("user.home"))
val currDirPath = Paths.get(props("user.dir"))

// get the dotFiles directory
require(args.length == 0 || args.length == 1, "not correct number of args")
val dotFilesPath = if(args.length == 0) currDirPath else Paths.get(args(0))
require(Files.isDirectory(dotFilesPath), s"$dotFilesPath is not a directory")

// get the link files
val excludeFiles = Set("README.md", "sync.sh", "sync2.sh", ".git")
val dotFiles = Files
    .newDirectoryStream(dotFilesPath, "*")
    .filter(f => !excludeFiles.contains(f.getFileName.toString)) // filter out .git
    .map(_.toRealPath())
    .toList
require(dotFiles.length > 0, "not enough files")

val destPath = Paths.get(homeDirPath.toString).toRealPath()
require(Files.isDirectory(destPath), s"$destPath is not a directory")

// perform the linkage
for(dotFile <- dotFiles) {
  val dotFilePath = Paths.get(destPath.toString, dotFile.getFileName.toString)
  Try(Files.delete(dotFilePath))
  Files.createSymbolicLink(dotFilePath, dotFile)
  println(s"Created $dotFilePath")
}
