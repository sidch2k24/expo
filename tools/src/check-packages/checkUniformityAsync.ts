import os from 'os';
import path from 'path';

import { EXPO_DIR } from '../Constants';
import logger from '../Logger';
import { Package } from '../Packages';
import { spawnAsync } from '../Utils';

/**
 * Checks whether the state of files is the same after running a script.
 * @param pkg Package to check
 * @param match Path or pattern of the files to match
 */
export default async function checkUniformityAsync(pkg: Package, match: string): Promise<void> {
  if (os.platform() === 'win32') {
    // On Windows, we touch the files to force git for the CRLF -> LF conversion.
    // This is a workaround for the fact that Git on Windows does not automatically convert CRLF to LF.
    // warning: in the working copy of 'build/test.d.ts', CRLF will be replaced by LF the next time Git touches it
    await spawnAsync('git', ['add', '-u', match], {
      stdio: 'ignore',
      cwd: pkg.path,
    });
    await spawnAsync('git', ['reset', match], {
      stdio: 'ignore',
      cwd: pkg.path,
    });
  }
  const child = await spawnAsync('git', ['status', '--porcelain', match], {
    stdio: 'pipe',
    cwd: pkg.path,
  });
  const lines = child.stdout ? child.stdout.trim().split(/\r\n?|\n/g) : [];

  if (lines.length > 0) {
    logger.error(`The following files need to be rebuilt and committed:`);
    lines.map((line) => {
      const filePath = path.join(EXPO_DIR, line.replace(/^\s*\S+\s*/g, ''));
      logger.warn(path.relative(pkg.path, filePath));
    });

    throw new Error(`${pkg.packageName} has uncommitted changes after building.`);
  }
}
