/**
 * Patches FFDec swf2xml output to add one custom head bitmap/shape
 * and one new frame on sprite 316 (Heads_46).
 *
 * Usage:
 *   node inject-custom-head.js <work.xml> <assets/images dir> [pngPath] [frameNum]
 */
const fs = require("fs");
const path = require("path");

const DEFAULT_PNG = path.join(__dirname, "..", "decompiled", "images", "901.png");
const DEFAULT_FRAME = 31;
const BITMAP_ID = 901;
const SHAPE_ID = 903;
const TEMPLATE_SHAPE_ID = 263;
const SPRITE316_MARKER =
  '<item type="DefineSpriteTag" forceWriteAsLong="true" frameCount="30" hasEndTag="true" spriteId="316">';

function extractShapeBlock(xml, shapeId) {
  const re = new RegExp(
    `    <item type="DefineShapeTag"[^>]*shapeId="${shapeId}"[\\s\\S]*?\\n    </item>`,
    "m"
  );
  const match = xml.match(re);
  if (!match) {
    throw new Error(`Template shape ${shapeId} not found`);
  }
  return match[0];
}

function cloneShapeBlock(xml, templateShapeId, newShapeId, bitmapId) {
  let block = extractShapeBlock(xml, templateShapeId);
  block = block.replace(`shapeId="${templateShapeId}"`, `shapeId="${newShapeId}"`);
  block = block.replace(/bitmapId="262"/g, `bitmapId="${bitmapId}"`);
  return block;
}

function buildInsertBlock(xml, assetsRel, pngFile) {
  const lines = [
    `    <item type="DefineBitsLossless2Tag" _externalFile="${assetsRel}/${pngFile}" characterID="${BITMAP_ID}"/>`,
    cloneShapeBlock(xml, TEMPLATE_SHAPE_ID, SHAPE_ID, BITMAP_ID),
  ];
  return lines.join("\n");
}

function sprite316HasCustomFrame(xml) {
  const start = xml.indexOf('spriteId="316"');
  if (start < 0) return false;
  const end = xml.indexOf("</item>", xml.indexOf("</subTags>", start));
  const block = xml.slice(start, end);
  return block.includes(`characterId="${SHAPE_ID}"`);
}

function patchSprite316(xml, frameNum) {
  if (!xml.includes('spriteId="316"')) {
    throw new Error("Sprite 316 not found");
  }

  xml = xml.replace(
    /frameCount="30" hasEndTag="true" spriteId="316"/,
    `frameCount="${frameNum}" hasEndTag="true" spriteId="316"`
  );

  if (sprite316HasCustomFrame(xml)) {
    return xml;
  }

  const extraFrame = `
        <item type="PlaceObject2Tag" characterId="${SHAPE_ID}" depth="1" forceWriteAsLong="false" placeFlagHasCharacter="true" placeFlagHasClipActions="false" placeFlagHasClipDepth="false" placeFlagHasColorTransform="false" placeFlagHasMatrix="false" placeFlagHasName="false" placeFlagHasRatio="false" placeFlagMove="true"/>
        <item type="ShowFrameTag" forceWriteAsLong="false"/>`;

  const anchor =
    /(<item type="PlaceObject2Tag" characterId="315" depth="1"[\s\S]*?<item type="ShowFrameTag" forceWriteAsLong="false"\/>)(\s*<\/subTags>\s*<\/item>\s*<item type="PlaceObject2Tag" characterId="316")/;
  if (!anchor.test(xml)) {
    throw new Error("Could not find sprite 316 frame anchor for custom head");
  }

  xml = xml.replace(anchor, `$1${extraFrame}$2`);

  if (!sprite316HasCustomFrame(xml)) {
    throw new Error(`Failed to append custom head frame to sprite 316`);
  }

  return xml;
}

function main() {
  const xmlPath = process.argv[2];
  const imagesDir = process.argv[3];
  const pngPath = process.argv[4] || DEFAULT_PNG;
  const frameNum = Number(process.argv[5] || DEFAULT_FRAME);

  if (!xmlPath || !imagesDir) {
    console.error(
      "Usage: node inject-custom-head.js <work.xml> <assets/images dir> [pngPath] [frameNum]"
    );
    process.exit(1);
  }

  if (frameNum !== 31) {
    throw new Error(`Only frame 31 is supported currently (got ${frameNum})`);
  }

  const pngFile = path.basename(pngPath);
  fs.mkdirSync(imagesDir, { recursive: true });
  fs.copyFileSync(pngPath, path.join(imagesDir, pngFile));

  const xmlBase = path.basename(xmlPath, path.extname(xmlPath));
  const assetsRel = `${xmlBase}_assets/images`;

  let xml = fs.readFileSync(xmlPath, "utf8");

  if (!xml.includes(`characterID="${BITMAP_ID}"`)) {
    const insertAt = xml.indexOf(SPRITE316_MARKER);
    if (insertAt < 0) {
      throw new Error("Could not find insertion point before sprite 316");
    }
    const insertBlock = buildInsertBlock(xml, assetsRel, pngFile);
    xml = xml.slice(0, insertAt) + insertBlock + "\n" + xml.slice(insertAt);
  }

  xml = patchSprite316(xml, frameNum);
  fs.writeFileSync(xmlPath, xml);
  console.log(`Patched ${xmlPath}: custom head on sprite 316 frame ${frameNum} (${pngFile})`);
}

main();
