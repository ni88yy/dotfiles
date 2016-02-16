#!/bin/sh
  exec scala -feature "$0" "$@"
!#
import java.nio.file._
import scala.collection.JavaConversions._
import scala.sys._
import scala.sys.process._
import scala.util.Try
import sun.nio.fs._

// set up the user and current directory
val homeDirPath = Paths.get(props("user.home"))
val currDirPath = Paths.get(props("user.dir"))
val excludeFiles = Set("README.md", "sync.sh", "sync2.sh", ".git", ".DS_Store")

// get the dotFiles directory
require(args.length == 0 || args.length == 1, "not correct number of args")
val dotFilesPath = if(args.length == 0) currDirPath else Paths.get(args(0))
require(Files.isDirectory(dotFilesPath), s"$dotFilesPath is not a directory")

// get dest path
val destPath = Paths.get(homeDirPath.toString).toRealPath()
require(Files.isDirectory(destPath), s"$destPath is not a directory")

// makes sure there are dot files
val dotFiles = getDotFiles(dotFilesPath)
require(dotFiles.length > 0, "not enough files")

def getDotFiles(path:Path):List[Path] = {
  Files
    .newDirectoryStream(path, "*")
    .filter(f => !excludeFiles.contains(f.getFileName.toString)) // filter out .git
    .map(_.toRealPath())
    .toList
}

def processFiles(sourcePath:Path, destPath:Path):Unit = {
  getDotFiles(sourcePath) foreach { dotFile =>
    if(dotFile.toFile.isDirectory) {
      val newSourcePath = Paths.get(sourcePath.toString, dotFile.getFileName.toString)
      val newDestPath = Paths.get(destPath.toString, dotFile.getFileName.toString)
      val newDestDir = newDestPath.toFile
      if(!newDestDir.isDirectory) {
        newDestDir.mkdirs
        println(s"Created $newDestDir")
      }
      processFiles(newSourcePath, newDestPath)
    } else {
      val dotFilePath = Paths.get(destPath.toString, dotFile.getFileName.toString)
      Try(Files.delete(dotFilePath))
      Files.createSymbolicLink(dotFilePath, dotFile)
      println(s"Created $dotFilePath")
    }
  }
}

processFiles(currDirPath, homeDirPath)

// perform the linkage
//for(dotFile <- dotFiles) {
//  val dotFilePath = Paths.get(destPath.toString, dotFile.getFileName.toString)
//  Try(Files.delete(dotFilePath))
//  Files.createSymbolicLink(dotFilePath, dotFile)
//  println(s"Created $dotFilePath")
//}
